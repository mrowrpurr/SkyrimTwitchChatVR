import asyncio
import os

import websockets
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
        twitch_username = message.author.name
        twitch_color = (message.author.colour or "#000000").replace("#", "0x")  # Default to black if color is None
        twitch_message = message.content

        self.gui_callback(f"{twitch_color}|{twitch_username}: {twitch_message}")

        chunk_size = 69
        for i in range(0, len(twitch_message), chunk_size):
            if i == 0:
                chunk = f"{twitch_color}|{twitch_username}: {twitch_message[i:i+chunk_size]}"
            else:
                chunk = f"{twitch_color}|    {twitch_message[i:i+chunk_size]}"
            async with websockets.connect("ws://mrowr:6969") as websocket:
                await websocket.send(chunk)
                await asyncio.sleep(0.1)  # 100 ms sleep to ensure ordering



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
            self.connect_button.setText("Connect")
            self.bot = None
            self.timer.stop()
        else:
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
            self.timer.start(0)

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