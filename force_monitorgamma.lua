local GetUi = ui.get
local NewSlider = ui.new_slider
local AddEvent = client.set_event_callback
local GetCVar = client.get_cvar
local SetCVar = client.set_cvar
local brightness = NewSlider("visuals", "effects", "Force brightness", 50, 350, GetCVar("mat_monitorgamma") * 100, true, "", .01)
AddEvent("run_command", function()
	SetCVar("mat_monitorgamma", GetUi(brightness) *.01)
end)
