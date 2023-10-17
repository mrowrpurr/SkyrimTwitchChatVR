scriptName ScriptTracker hidden

function SaveScript(Form theScriptForm, string nameOfScript = "") global
    if ! nameOfScript
        nameOfScript = __GetNameOfScript(theScriptForm)
    endIf
    Debug.Notification("SAVE: " + nameOfScript)
    JDB.solveFormSetter(".mrowr.scripts." + nameOfScript, theScriptForm, createMissingKeys = true)
endFunction

Form function GetScript(string nameOfScript) global
    return JDB.solveForm(".mrowr.scripts." + nameOfScript)
endFunction

string function __GetNameOfScript(Form theScriptForm) global
    return StringUtil.Substring(theScriptForm, 1, StringUtil.Find(theScriptForm, " ") - 1)
endFunction
