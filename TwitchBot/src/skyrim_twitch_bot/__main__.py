import asyncio
import os

from dotenv import load_dotenv
from PySide6.QtCore import QTimer, Slot
from PySide6.QtWidgets import (QApplication, QPushButton, QTextEdit,
                               QVBoxLayout, QWidget)
from twitchio.ext import commands

load_dotenv(dotenv_path="D:/Dropbox/Twitch/Bots/Access Tokens/.env")

class TwitchBot(commands.Bot):

    def __init__(self, irc_token, client_id, nick, initial_channels, gui_callback):
        super().__init__(token=irc_token, client_id=client_id, nick=nick, prefix="!", initial_channels=initial_channels)
        self.gui_callback = gui_callback

    async def event_ready(self):
        print(f"Ready | {self.nick}")

    async def event_message(self, message):
        self.gui_callback(message.content)

class TwitchBotWindow(QWidget):

    def __init__(self):
        super().__init__()

        self.bot = None

        self.setWindowTitle("Skyrim Twitch Bot")
        self.text_edit = QTextEdit()
        self.connect_button = QPushButton("Connect")
        self.connect_button.clicked.connect(self.toggle_connection)

        layout = QVBoxLayout()
        layout.addWidget(self.text_edit)
        layout.addWidget(self.connect_button)
        self.setLayout(layout)

        self.timer = QTimer(self)
        self.timer.timeout.connect(self.run_pending_tasks)

    def run_pending_tasks(self):
        loop = asyncio.get_event_loop()
        loop.stop()
        loop.run_forever()

    @Slot()
    def toggle_connection(self):
        if self.bot:
            # Disconnect logic (TwitchIO doesn"t provide a disconnect method)
            self.connect_button.setText("Connect")
            self.bot = None
            self.timer.stop()
        else:
            load_dotenv(dotenv_path="path/to/your/.env")
            irc_token = os.getenv("TMI_TOKEN")
            client_id = os.getenv("CLIENT_ID")
            bot_username = os.getenv("BOT_USERNAME")
            channel_name = os.getenv("CHANNEL_NAME")

            loop = asyncio.get_event_loop()
            self.bot = TwitchBot(
                irc_token=irc_token,
                client_id=client_id,
                nick=bot_username,
                initial_channels=[channel_name],
                gui_callback=self.update_textbox
            )
            loop.create_task(self.bot.start())
            self.connect_button.setText("Disconnect")
            self.timer.start(0)  # Run as fast as possible

    def update_textbox(self, message: str):
        self.text_edit.append(message)

def main():
    import sys

    app = QApplication(sys.argv)
    window = TwitchBotWindow()
    window.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
