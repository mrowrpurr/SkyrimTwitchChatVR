scriptName MP_GenericFlashTextWidget extends SKI_WidgetBase
{
### Note: as a SkyUI widget, it must be attached to a Quest (not an object)

This widget is originally from SLAM (`SLAM_TextWidget`), thank you to `BeamerMiasma`
- LE (_original_): https://www.loverslab.com/files/file/1535-sexlab-aroused-monitor-widget/
- SE (_conversion by Ecohex_): https://www.loverslab.com/files/file/11466-sexlab-aroused-monitor-widget-se/
    
### Permissions
> You are free to use parts of the scripts & CK objects from this mod in your own projects, credits would be nice.
> ~ BeamerMiasma

Thank you, because I don't want to make a Flash widget in 2022 :)
}

;;;; Notes:
;       this._x = this._messageText._x;
;       this._x = this._messageText._y;
;    }
;    function updatePosition()
;    {
;       super.updatePosition();
;       this._messageText._x = this._x;
;       this._messageText._y = this._y;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

string property Font_Console = "$ConsoleFont" autoReadonly
string property Font_StartMenu = "$StartMenuFont" autoReadonly
string property Font_Dialogue = "$DialogueFont" autoReadonly
string property Font_Default = "$EverywhereFont" autoReadonly
string property Font_Bold = "$EverywhereBoldFont" autoReadonly
string property Font_Medium = "$EverywhereMediumFont" autoReadonly
string property Font_Dragon = "$DragonFont" autoReadonly
string property Font_Books = "$SkyrimBooks" autoReadonly
string property Font_Handwritten = "$HandwrittenFont" autoReadonly
string property Font_Handwritten_Bold = "$HandwrittenBold" autoReadonly
string property Font_Falmer = "$FalmerFont" autoReadonly
string property Font_Dwemer = "$DwemerFont" autoReadonly
string property Font_Daedric = "$DaedricFont" autoReadonly
string property Font_Mage = "$MageScriptFont" autoReadonly
string property Font_Symbols = "$SkyrimSymbolsFont" autoReadonly
string property Font_Books_Unreadable = "$SkyrimBooks_UnreadableFont" autoReadonly
string property TextAlign_Left = "left" autoReadonly
string property TextAlign_Right = "right" autoReadonly
string property TextAlign_Center = "center" autoReadonly

string function GetWidgetType()
    return "UITextWidget"
endfunction

string function GetWidgetSource()
    return "UITextWidget/UITextWidget.swf"
endfunction

event OnWidgetInit()
    RegisterForSingleUpdate(0.1)
endEvent

event OnUpdate()
    if IsLoaded
        InitializeWidgetUI()
        OnWidgetReady()
    else
        RegisterForSingleUpdate(0.1)
    endIf
endEvent

function InitializeWidgetUI()
    Text = ""
    Alpha = 100
    VAnchor = "Top"
    HAnchor = "Left"
    SetTextAlign()
    SetFont()
    SetTextSize()
    SetColor()
    Show()
endFunction

event OnWidgetReady()
endEvent

bool property IsLoaded
    bool function get()
        ; Should be "left" but can be anything to prove the Flash widget is ready
        return UI.GetString(HUD_MENU, WidgetRoot + "._messageText.autoSize")
    endFunction
endProperty

; Fonts ;
; https://stepmodifications.org/wiki/Guide:UnderstandingFonts
string[] function GetValidFontNames()
    string[] fontNames = new string[16]
    fontNames[0] = "$ConsoleFont"
    fontNames[1] = "$StartMenuFont"
    fontNames[2] = "$DialogueFont"
    fontNames[3] = "$EverywhereFont"
    fontNames[4] = "$EverywhereBoldFont"
    fontNames[5] = "$EverywhereMediumFont"
    fontNames[6] = "$DragonFont"
    fontNames[7] = "$SkyrimBooks"
    fontNames[8] = "$HandwrittenFont"
    fontNames[9] = "$HandwrittenBold"
    fontNames[10] = "$FalmerFont"
    fontNames[11] = "$DwemerFont"
    fontNames[12] = "$DaedricFont"
    fontNames[13] = "$MageScriptFont"
    fontNames[14] = "$SkyrimSymbolsFont"
    fontNames[15] = "$SkyrimBooks_UnreadableFont"
    return fontNames
endFunction

float property Width
	float function get()
		return UI.GetFloat(HUD_MENU, WidgetRoot + "._width")
	endFunction
	function set(float value)
		UI.SetFloat(HUD_MENU, WidgetRoot + "._width", value)
	endFunction
endProperty

float function GetWidth()
    return self.Width
endFunction

function SetWidth(float w)
    self.Width = w
endFunction

float property Height
	float function get()
		return UI.GetFloat(HUD_MENU, WidgetRoot + "._height")
	endFunction
	function set(float value)
		UI.SetFloat(HUD_MENU, WidgetRoot + "._height", value)
	endFunction
endProperty

float function GetHeight()
    return self.Height
endFunction

function SetHeight(float h)
    self.Height = h
endFunction

string property Text
    string function get()
		return UI.GetString(HUD_MENU, WidgetRoot + "._messageText.text")
	endFunction
	function set(string value)
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setMessageText", value)
	endFunction
endProperty

function SetText(string text)
    UI.InvokeString(HUD_MENU, WidgetRoot + ".setMessageText", text)
endFunction

bool property Visible
	bool function get()
		return UI.GetBool(HUD_MENU, WidgetRoot + "._messageText._visible")
	endFunction
	function set(bool value)
		UI.InvokeBool(HUD_MENU, WidgetRoot + ".setVisible", value)
	endFunction
endProperty

int property Color
    function set(int hexColor)
        SetColor(hexColor)
    endFunction
endProperty

function Show()
    Visible = true
endFunction

function Hide()
    Visible = false
endFunction

; See UITextWidget.GetValidFontNames()
; - $ConsoleFont
; - $StartMenuFont
; - $DialogueFont
; - $EverywhereFont
; - $EverywhereBoldFont
; - $EverywhereMediumFont
; - $DragonFont
; - $SkyrimBooks
; - $HandwrittenFont
; - $HandwrittenBold
; - $FalmerFont
; - $DwemerFont
; - $DaedricFont
; - $MageScriptFont
; - $SkyrimSymbolsFont
; - $SkyrimBooks_UnreadableFont
function SetFont(string fontName = "$EverywhereMediumFont")
    UI.InvokeString(HUD_MENU, WidgetRoot + ".setFont", fontName)
endFunction

function SetTextSize(int textSize = 12)
    UI.InvokeNumber(HUD_MENU, WidgetRoot + ".setTextSize", textSize)
endFunction

function SetColor(int hexColor = 0xffffff)
    UI.InvokeNumber(HUD_MENU, WidgetRoot + ".setTextColor", hexColor)
endFunction

; Left, Right, or Center
function SetTextAlign(string alignment = "left")
    UI.InvokeString(HUD_MENU, WidgetRoot + ".setAlign", alignment)
endFunction

int function GetScreenWidth()
    return Utility.GetIniInt("iSize W:Display")
endFunction

int function GetScreenHeight()
    return Utility.GetIniInt("iSize H:Display")
endFunction

function CenterHorizontally()
    ; 1920 seems to treat (1920/2) as full width, I don't fully understand wth?
    X = (GetScreenWidth() / 4)
endFunction

function CenterVertically()
    Y = (GetScreenHeight() / 2)
endFunction

function MoveToTop(int padding = 0)
    Y = padding
endFunction

function MoveToBottom(int padding = 0)
    Y = GetScreenHeight() - Height - padding
endFunction

function MoveToRight(int padding = 0)
    X = GetScreenWidth() - Width - padding
endFunction

function MoveToLeft(int padding = 0)
    X = padding
endFunction

function SetX(int _x)
    self.X = _x
endFunction

function SetY(int _y)
    self.Y = _y
endFunction

float function GetX()
    return self.X
endFunction

float function GetY()
    return self.Y
endFunction

function MoveTo(float _x, float _y)
    self.X = _x
    self.Y = _y
endFunction

function Resize(int _width, int _height)
    self.Width = _width
    self.Height = _height
endFunction
