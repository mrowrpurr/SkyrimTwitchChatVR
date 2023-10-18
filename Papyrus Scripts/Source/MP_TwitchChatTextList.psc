scriptName MP_TwitchChatTextList hidden

function Reset() global
    int items = JArray.object()
    JDB.solveObjSetter(".TwitchChatVR.textList", items, createMissingKeys = true)
endFunction

int function GetItems() global
    int items = JDB.solveObj(".TwitchChatVR.textList")
    if ! items
        Reset()
        items = JDB.solveObj(".TwitchChatVR.textList")
    endIf
    return items
endFunction

function AddItem(string text, int color = 0xf) global
    int items = GetItems()
    int itemCount = JArray.count(items)
    int maxItemCount = MP_TwitchChatConfiguration.WidgetCount()
    if itemCount >= maxItemCount
        JArray.eraseIndex(items, 0)
    endIf
    int item = JMap.object()
    JMap.setInt(item, "color", color)
    JMap.setStr(item, "text", text)
    JArray.addObj(items, item)
endFunction

int function GetItem(int index) global
    return JArray.getObj(GetItems(), index)
endFunction

string function ReadItemText(int item) global
    return JMap.getStr(item, "text")
endFunction

int function ReadItemColor(int item) global
    return JMap.getInt(item, "color")
endFunction
