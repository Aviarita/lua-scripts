local GetUi = ui.get
local SetUi = ui.set
local NewSlider = ui.new_slider
local NewCheckbox = ui.new_checkbox
local NewHotkey = ui.new_hotkey
local NewRef = ui.reference
local SetVisible = ui.set_visible
local SetCallback = ui.set_callback

local GetLocalPlayer = entity.get_local_player

local Log = client.log

local AddEvent = client.set_event_callback

local rage, aimbot = "rage", "aimbot"

local ui = {
    ref = {
        hc = NewRef(rage, aimbot, "minimum hit chance"),
    	min_dmg = NewRef(rage, aimbot, "minimum damage")
    },
    
    enabled = NewCheckbox(rage, aimbot, "Enable in/decrease hotkeys"),
    
    hitchance = NewSlider(rage, aimbot, "In/decrease hit chance by", 0, 15, 5),
    hitchance_increase_key = NewHotkey(rage, aimbot, "Increase key"),
    hitchance_decrease_key = NewHotkey(rage, aimbot, "Decrease key"),
    
    min_dmg = NewSlider(rage, aimbot, "In/decrease minimum damage by", 0, 15, 5),
    min_dmg_increase_key = NewHotkey(rage, aimbot, "Increase key"),
	min_dmg_decrease_key = NewHotkey(rage, aimbot, "Decrease key")
}

local function clamp(min, max, current)
    if current > max then
        current = max
    elseif current < min then
        current = min
    end
    return math.floor(current)
end

local tickcount = globals.tickcount
local lasttick = tickcount()

local function timer(delay, f)
    local now = tickcount()
    if lasttick < now - delay then
        f()
        lasttick = now
    end
end

SetVisible(ui.hitchance, false)
SetVisible(ui.hitchance_increase_key, false)
SetVisible(ui.hitchance_decrease_key, false)
SetVisible(ui.min_dmg, false)
SetVisible(ui.min_dmg_increase_key, false)
SetVisible(ui.min_dmg_decrease_key, false)

SetCallback(ui.enabled, function()
    SetVisible(ui.hitchance, GetUi(ui.enabled))
    SetVisible(ui.hitchance_increase_key, GetUi(ui.enabled))
    SetVisible(ui.hitchance_decrease_key, GetUi(ui.enabled))
    SetVisible(ui.min_dmg, GetUi(ui.enabled))
    SetVisible(ui.min_dmg_increase_key, GetUi(ui.enabled))
    SetVisible(ui.min_dmg_decrease_key, GetUi(ui.enabled))
end)

client.set_event_callback('paint', function(ctx)
	    if GetUi(ui.enabled) == false then return end
    
    local now = tickcount()
    
    local cur_hc = GetUi(ui.ref.hc)
    local cur_min_dmg = GetUi(ui.ref.min_dmg)
    
    if GetUi(ui.hitchance_increase_key) == true and GetUi(ui.hitchance_decrease_key) == false then
        timer(10, function()
            local new_hc = clamp(0, 100, cur_hc + GetUi(ui.hitchance))
            SetUi(ui.ref.hc, new_hc)
            Log("Set hitchance to: ", new_hc)
        end)
    elseif GetUi(ui.hitchance_decrease_key) == true and GetUi(ui.hitchance_increase_key) == false then
        timer(10, function()
            local new_hc = clamp(0, 100, cur_hc - GetUi(ui.hitchance))
            SetUi(ui.ref.hc, new_hc)
            Log("Set hitchance to: ", new_hc)
        end)
    elseif GetUi(ui.hitchance_decrease_key) == true and GetUi(ui.hitchance_increase_key) == true then
        timer(10, function()
            Log("You can't do both at once.")
        end)
    end
    
    if GetUi(ui.min_dmg_increase_key) == true and GetUi(ui.min_dmg_decrease_key) == false then
        timer(10, function()
            local new_min_dmg = clamp(0, 126, cur_min_dmg + GetUi(ui.min_dmg))
            SetUi(ui.ref.min_dmg, new_min_dmg)
            Log("Set minimum damage to: ", new_min_dmg)
        end)
    elseif GetUi(ui.min_dmg_decrease_key) == true and GetUi(ui.min_dmg_increase_key) == false then
        timer(10, function()
            local new_min_dmg = clamp(0, 126, cur_min_dmg - GetUi(ui.min_dmg))
            SetUi(ui.ref.min_dmg, new_min_dmg)
            Log("Set minimum damage to: ", new_min_dmg)
        end)
    elseif GetUi(ui.min_dmg_decrease_key) == true and GetUi(ui.min_dmg_increase_key) == true then
        timer(10, function()
            Log("You can't do both at once.")
        end)
    end

   
end)
client.set_event_callback('cs_game_disconnected', function()
	lasttick = -1
end)
