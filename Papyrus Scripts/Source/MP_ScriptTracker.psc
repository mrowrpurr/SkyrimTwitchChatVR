scriptName MP_ScriptTracker hidden

function SaveScript(Form theScriptForm, string nameOfScript = "") global
    if ! nameOfScript
        nameOfScript = __GetNameOfScript(theScriptForm)
    endIf
    JDB.solveFormSetter(".mrowr.scripts." + nameOfScript, theScriptForm, createMissingKeys = true)
    Debug.Trace("(Widget) Save Script: " + nameOfScript + " - " + theScriptForm)
endFunction

Form function GetScript(string nameOfScript) global
    Form found = JDB.solveForm(".mrowr.scripts." + nameOfScript)
    if ! found
        Debug.Trace("(Widget) Get Script: " + nameOfScript + " - Not Found")
    endIf
    return found
endFunction

string function __GetNameOfScript(Form theScriptForm) global
    return StringUtil.Substring(theScriptForm, 1, StringUtil.Find(theScriptForm, " ") - 1)
endFunction
