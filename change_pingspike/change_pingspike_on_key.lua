local GetUi = ui.get
local SetUi = ui.set
local NewSlider = ui.new_slider
local NewKey = ui.new_hotkey
local NewRef = ui.reference
local SetVisible = ui.set_visible
local AddEvent = client.set_event_callback

local pingspike_cb, _, pingspike_slider = NewRef("misc", "miscellaneous", "ping spike")
local new_pingspike_key = NewKey("misc", "miscellaneous", "New ping spike (on key press)")
local new_pingspike_value = NewSlider("misc", "miscellaneous", "New ping spike (on key press)", 1, 750, 200)

local old_value = GetUi(pingspike_slider)

local should_change = 0

SetVisible(new_pingspike_key, false)
SetVisible(new_pingspike_value, false)

AddEvent("run_command", function()
    if GetUi(new_pingspike_key) then
        SetUi(pingspike_slider, GetUi(new_pingspike_value))
        should_change = 1
    elseif GetUi(pingspike_slider) ~= old_value and should_change == 1 then
        should_change = 0
        SetUi(pingspike_slider, old_value)
    elseif GetUi(new_pingspike_key) ~= true then
        old_value = GetUi(pingspike_slider)
    end
    
    SetVisible(new_pingspike_key, GetUi(pingspike_cb))
    SetVisible(new_pingspike_value, GetUi(pingspike_cb))
end)
