local GetUi = ui.get
local SetUi = ui.set
local NewSlider = ui.new_slider
local NewKey = ui.new_hotkey
local NewRef = ui.reference
local SetVisible = ui.set_visible
local AddEvent = client.set_event_callback

local GetLocalPlayer = entity.get_local_player
local GetAll = entity.get_all
local GetProp = entity.get_prop

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

-- credits to chay --

time_start = globals.realtime()

local function rgb_percents(percentage)
    local r = 124 * 2 - 165 * percentage
    local g = 260 * percentage
    local b = 13
    return r, g, b
end

AddEvent("paint", function(ctx)
        
    if GetLocalPlayer() == nil then return end
       
    if diff_old == nil then
        diff_old = 0
    end
    
    local player_resource = GetAll("CCSPlayerResource")[1]
    if player_resource == nil then return end
    local ping = GetProp(player_resource, "m_iPing", GetLocalPlayer())
    if ping == nil then return end
    local maxping = GetUi(new_pingspike_value)
    if maxping == nil then return end
    local diff = math.floor(ping / maxping * 100)
    if diff == nil then return end
    
    if diff_old ~= diff and globals.realtime() - time_start > 0.03 then
        time_start = globals.realtime()
        if diff_old > diff then i = -1 else i = 1 end
        diff_old = diff_old + i
    end
    
    if diff < 75 and diff > 0 then
        r, g, b = rgb_percents(diff_old / 100)
    elseif diff >= 75 then
        r, g, b = 124, 195, 13
    elseif diff < 0 then
        r, g, b = 237, 27, 3
    end
    
    client.draw_indicator(ctx, r, g, b, 255, "Cur: " .. ping)
    
    if GetUi(new_pingspike_key) == false then return end
    client.draw_indicator(ctx, 124, 195, 13, 255, "Max: " .. maxping)
end)

