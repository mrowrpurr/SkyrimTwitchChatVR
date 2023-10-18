scriptName MP_TwitchChatTextWidget extends MP_GenericFlashTextWidget

event OnWidgetReady()
    MP_ScriptTracker.SaveScript(self, GetEditorId())
endEvent

string function GetEditorId()
    string selfText = self ; [MP_TwitchChatTextWidget <mp_twitchchattextwidget69 (FF00AABBCC)>]
    int angleBracketIndex = StringUtil.Find(selfText, "<")
    int secondSpace = StringUtil.Find(selfText, " ", angleBracketIndex)
    string selfEditorId = StringUtil.Substring(selfText, angleBracketIndex + 1, secondSpace - angleBracketIndex - 1)
    return selfEditorId
endFunction

string function GetWidgetName(int widgetNumber) global
    ; 2 character number
    string number = widgetNumber
    if StringUtil.GetLength(number) == 1
        number = "0" + number
    endIf
    return "MP_TwitchChatTextWidget" + number
endFunction

MP_TwitchChatTextWidget function Get(int widgetNumber) global
    return MP_ScriptTracker.GetScript(GetWidgetName(widgetNumber)) as MP_TwitchChatTextWidget
endFunction
