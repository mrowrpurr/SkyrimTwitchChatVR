scriptName MP_TwitchChatConfiguration hidden

int function Get() global
    return JDB.solveObj(".TwitchChatVR.config")
endFunction

int function Load(string configFilePath = "Data/TwitchChatVR.json") global
    int config = JValue.readFromFile(configFilePath)
    if config
        JDB.solveObjSetter(".TwitchChatVR.config", config, createMissingKeys = true)
    else
        Debug.Trace("(Widget) Failed to load TwitchChatVR config file: " + configFilePath)
    endIf
    return Get()
endFunction

int function WidgetCount() global
    return JMap.getInt(Get(), "count", 0)
endFunction

int function X() global
    return JMap.getInt(Get(), "x", 0)
endFunction

int function Y() global
    return JMap.getInt(Get(), "y", 0)
endFunction

int function Width() global
    return JMap.getInt(Get(), "width", 0)
endFunction

int function Height() global
    return JMap.getInt(Get(), "height", 0)
endFunction

int function TextSize() global
    return JMap.getInt(Get(), "textSize", 0)
endFunction

string function FontFamily() global
    return JMap.getStr(Get(), "fontFamily", 0)
endFunction
