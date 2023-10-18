scriptName MP_TwitchChatWidgetManager extends Actor

function Log(string text) global
    Debug.Trace("MP_TwitchChatWidgetManager: " + text)
endFunction

bool _initializingWidgets = false

MP_TwitchChatWidgetManager function Get() global
    return MP_ScriptTracker.GetScript("MP_TwitchChatWidgetManager") as MP_TwitchChatWidgetManager
endFunction

event OnInit()
    Log("OnInit")
    MP_ScriptTracker.SaveScript(self, "MP_TwitchChatWidgetManager")
    InitializeWidgets()
endEvent

event OnPlayLoadGame()
    Log("OnPlayLoadGame")
    InitializeWidgets()
endEvent

event OnUpdate()
    if _initializingWidgets
        if TryInitializeAllWidgets()
            _initializingWidgets = false
        else
            RegisterForSingleUpdate(1.0)
        endIf
    endIf
endEvent

bool function TryInitializeAllWidgets()
    Log("TryInitializeAllWidgets")
    bool allInitialized = true
    int widgetCount = MP_TwitchChatConfiguration.WidgetCount()
    Log("TryInitializeAllWidgets, widget count: " + widgetCount)
    int i = 0
    while i < widgetCount
        int widgetNumber = i + 1
        if ! IsWidgetInitialized(widgetNumber)
            if TryInitializeWidget(widgetNumber)
                SetWidgetInitialized(widgetNumber)
            else
                allInitialized = false
            endIf
        endIf
        i = i + 1
    endWhile
    Log("TryInitializeAllWidgets, all initialized? " + allInitialized)
    return allInitialized
endFunction

bool function TryInitializeWidget(int widgetNumber)
    Log("TryInitializeWidget: " + widgetNumber)
    MP_TwitchChatTextWidget widget = MP_TwitchChatTextWidget.Get(widgetNumber)
    if ! widget
        return false
    endIf
    Log("Config x: " + MP_TwitchChatConfiguration.X() + ", y: " + MP_TwitchChatConfiguration.Y() + ", width: " + MP_TwitchChatConfiguration.Width() + ", height: " + MP_TwitchChatConfiguration.Height() + ", font: " + MP_TwitchChatConfiguration.FontFamily() + ", text size: " + MP_TwitchChatConfiguration.TextSize())
    int startingY = MP_TwitchChatConfiguration.Y()
    int _y = startingY + (widgetNumber - 1) * MP_TwitchChatConfiguration.Height()
    int _x = MP_TwitchChatConfiguration.X()
    Log("Moving widget " + widgetNumber + " to " + _x + ", " + _y)
    widget.MoveTo(_x, _y)
    widget.Resize(MP_TwitchChatConfiguration.Width(), MP_TwitchChatConfiguration.Height())
    widget.SetFont(MP_TwitchChatConfiguration.FontFamily())
    widget.SetTextSize(MP_TwitchChatConfiguration.TextSize())
    widget.Text = ""
    widget.Show()
    Log("Widget " + widgetNumber + " initialized")
    return true
endFunction

function InitializeWidgets()
    Log("InitializeWidgets")
    MP_TwitchChatConfiguration.Load()
    ResetWidgetInitializationStates()
    _initializingWidgets = true
    RegisterForSingleUpdate(1.0)
endFunction

int function GetWidgetInitializationStates() global
    return JDB.solveObj(".TwitchChatVR.widgetInitStates")
endFunction

function ResetWidgetInitializationStates() global
    Log("ResetWidgetInitializationStates")
    int states = JIntMap.object()
    JDB.solveObjSetter(".TwitchChatVR.widgetInitStates", states, createMissingKeys = true)
endFunction

bool function IsWidgetInitialized(int widgetNumber) global
    return JIntMap.getInt(GetWidgetInitializationStates(), widgetNumber) as bool
endFunction

function SetWidgetInitialized(int widgetNumber, bool initialized = true) global
    Log("SetWidgetInitialized: " + widgetNumber + ", " + initialized)
    int states = GetWidgetInitializationStates()
    if states
        JIntMap.setInt(states, widgetNumber, initialized as int)
    else
        Log("SetWidgetInitialized, states not found")
    endIf
endFunction

function RefreshWidgets() global
    int widgetCount = MP_TwitchChatConfiguration.WidgetCount()
    int i = 0
    while i < widgetCount
        int widgetNumber = i + 1
        MP_TwitchChatTextWidget widget = MP_TwitchChatTextWidget.Get(widgetNumber)
        if widget
            int messageItem = MP_TwitchChatTextList.GetItem(i)
            if messageItem
                int itemColor = MP_TwitchChatTextList.ReadItemColor(messageItem)
                string itemText = MP_TwitchChatTextList.ReadItemText(messageItem)
                widget.SetColor(itemColor)
                widget.Text = itemText
            else
                widget.Text = ""
            endIf
        else
            Log("Widget " + widgetNumber + " not found")
        endIf
        i += 1
    endWhile
endFunction
