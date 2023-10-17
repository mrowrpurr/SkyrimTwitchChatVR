scriptName TestShowingWidget extends Quest

event OnInit()
    RegisterForSingleUpdate(4.20)
endEvent

event OnUpdate()
    ExampleTextWidget widget = ExampleTextWidget.Get()

    if widget
        Debug.Trace("WILL SetupWidget()")
        SetupWidget(widget)
        Debug.Trace("DID SetupWidget()")
        Debug.Notification("Configuring widget...")
    else
        RegisterForSingleUpdate(4.20)
        Debug.Notification("Waiting for widget...")
    endIf
endEvent

function SetupWidget(ExampleTextWidget widget)
    Debug.Trace("SETUP WIDGET BEGIN")
    widget.Color = 0xFF00FF
    widget.SetTextSize(14)
    widget.SetFont(widget.Font_Default)
    widget.CenterHorizontally()
    widget.CenterVertically()

    widget.Text = "1. Message\n"
    widget.Text = widget.Text + "2. Message\n"
    widget.Text = widget.Text + "3. Message\n"
    widget.Text = widget.Text + "4. Message\n"
    widget.Text = widget.Text + "5. Message\n"
    widget.Text = widget.Text + "6. Message\n"
    widget.Text = widget.Text + "7. Message\n"
    widget.Text = widget.Text + "8. Message\n"
    widget.Text = widget.Text + "9. Message\n"
    widget.Text = widget.Text + "10. Message\n"

    widget.Show()
    Debug.Trace("SETUP WIDGET END")
    Debug.Notification("Widget setup complete.")
endFunction
