scriptName TwitchChatWidgetManager extends Quest

function Log(string text) global
    Debug.Trace("TwitchChatWidgetManager: " + text)
endFunction

event OnInit()
    ScriptTracker.SaveScript(self, "TwitchChatWidgetManager")
    RegisterForSingleUpdate(1)
endEvent

TwitchChatWidgetManager function Get() global
    return ScriptTracker.GetScript("TwitchChatWidgetManager") as TwitchChatWidgetManager
endFunction

int function GetTwitchChatTextLines() global
    int messageLines = JDB.solveObj(".twitchChatMessageLines")
    if ! messageLines
        messageLines = JArray.object()
        JDB.solveObjSetter(".twitchChatMessageLines", messageLines, createMissingKeys = true)
    endIf
    return messageLines
endFunction

function AddChatMessageLine(string messageText) global
    Log("AddChatMessageLine: " + messageText)
    int messageTextLines = GetTwitchChatTextLines()
    if JArray.count(messageTextLines) >= 10 ; Let's do 10 messages
        JArray.eraseIndex(messageTextLines, 0)
    endIf
    JArray.addStr(messageTextLines, messageText)
    RefreshText()
endFunction

function RefreshText() global
    TwitchChatTextWidget widget = TwitchChatTextWidget.Get()
    if ! widget
        return
    endIf

    int messageTextLines = GetTwitchChatTextLines()
    int messageTextLineCount = JArray.count(messageTextLines)
    string messageText = ""
    int i = 0
    while i < messageTextLineCount
        messageText = messageText + JArray.getStr(messageTextLines, i) + "\n"
        i = i + 1
    endWhile

    Log("RefreshText: " + messageText)
    widget.Text = messageText
endFunction

event OnUpdate()
    TwitchChatTextWidget widget = TwitchChatTextWidget.Get()

    if widget
        SetupWidget(widget)
    else
        RegisterForSingleUpdate(1)
    endIf
endEvent

function SetupWidget(TwitchChatTextWidget widget)
    Log("SetupWidget")

    widget.Color = 0xFF00FF
    widget.SetTextSize(14)
    widget.SetFont(widget.Font_Default)
    widget.CenterHorizontally()
    widget.CenterVertically()

    widget.Text = "<Twitch chat>"

    widget.Show()
endFunction
