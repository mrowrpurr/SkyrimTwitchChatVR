scriptName MP_TwitchChatAPI hidden

function ClearMessages() global
    Debug.Trace("MP_TwitchChatAPI: ClearMessages")
    MP_TwitchChatTextList.Reset()
    MP_TwitchChatWidgetManager.RefreshWidgets()
endFunction

function AddMessage(string text, int color = 0xf) global
    Debug.Trace("MP_TwitchChatAPI: AddMessage: " + text + " " + color)
    MP_TwitchChatTextList.AddItem(text, color)
    MP_TwitchChatWidgetManager.RefreshWidgets()
endFunction
