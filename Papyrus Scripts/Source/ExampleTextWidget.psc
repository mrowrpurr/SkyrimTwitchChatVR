scriptName ExampleTextWidget extends GenericFlashTextWidget

event OnWidgetReady()
    Debug.MessageBox("ExampleTextWidget is ready!")
    ScriptTracker.SaveScript(self, "ExampleTextWidget")
endEvent

ExampleTextWidget function Get() global
    ExampleTextWidget widget = ScriptTracker.GetScript("ExampleTextWidget") as ExampleTextWidget
    if widget
        return widget
    else
        Debug.Notification("Whaaaaa... GET returned none???")
        return None
    endIf
endFunction
