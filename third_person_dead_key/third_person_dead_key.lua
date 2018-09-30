local cb_ref = ui.reference("visuals", "effects", "Force third person (dead)")
local _, key_ref = ui.reference("visuals", "effects", "Force third person (alive)")
client.set_event_callback("paint", function(ctx) ui.set(cb_ref, ui.get(key_ref)) end)
