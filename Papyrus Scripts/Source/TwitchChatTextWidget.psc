scriptName TwitchChatTextWidget extends GenericFlashTextWidget

event OnWidgetReady()
    ScriptTracker.SaveScript(self, "TwitchChatTextWidget")
endEvent

TwitchChatTextWidget function Get() global
    return ScriptTracker.GetScript("TwitchChatTextWidget") as TwitchChatTextWidget
endFunction
