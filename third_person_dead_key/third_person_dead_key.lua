local cb_ref = ui.reference("visuals", "effects", "Force third person (dead)")
local key = ui.new_hotkey("visuals", "effects", "Force third person (dead) ")
client.set_event_callback("paint", function(ctx) ui.set(cb_ref, ui.get(key)) end)
