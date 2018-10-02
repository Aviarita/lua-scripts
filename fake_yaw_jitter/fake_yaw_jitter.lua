local GetUi = ui.get
local SetUi = ui.set
local NewSlider = ui.new_slider
local NewCombo = ui.new_combobox
local NewRef = ui.reference
local SetVisible = ui.set_visible
local SetCallback = ui.set_callback

local AddEvent = client.set_event_callback

local aa, aaa = "AA", "Anti-aimbot angles"

local ui = {
    yaw_jitter = NewCombo(aa, aaa, "Fake Yaw Jitter", {"Off", "Offset", "Center", "Random"}),
    yaw_jitter_slider = NewSlider(aa, aaa, "Fake Yaw Jitter", -180, 180, 0),
}

menu_fakeyaw_ref, menu_fakeyaw_offset_ref = NewRef(aa, aaa, "Fake yaw")

local tickcount = globals.tickcount
local lasttick = tickcount()

local function timer(delay, f)
    local now = tickcount()
    if lasttick < now - delay then
        f()
        lasttick = now
    end
end

local function clamp(min, max, current)
    if current > max then
        current = max
    elseif current < min then
        current = min
    end
    return math.floor(current)
end

function IsNumberNegative(intNumber)
    if(string.sub(tostring(intNumber), 1, 1) == "-") then
        return true;
    else
        return false
    end
    return nil
end

local fake_yaw = 0

local offset_jitter = 0
local center_jitter = 0
AddEvent("run_command", function()
    
    SetVisible(ui.yaw_jitter, GetUi(menu_fakeyaw_ref) ~= "Off")
    SetVisible(ui.yaw_jitter_slider, GetUi(ui.yaw_jitter) ~= "Off" and GetUi(menu_fakeyaw_ref) ~= "Off")
    
    if GetUi(menu_fakeyaw_ref) == "Sideways" then
        if IsNumberNegative(GetUi(ui.yaw_jitter_slider)) then
            if GetUi(ui.yaw_jitter) == "Offset" then
                fake_yaw = 90
            elseif GetUi(ui.yaw_jitter) == "Random" then
                fake_yaw = -90
            else
                fake_yaw = -90
            end
        else
            if GetUi(ui.yaw_jitter) == "Offset" then
                fake_yaw = -90
            elseif GetUi(ui.yaw_jitter) == "Random" then
                fake_yaw = 90
            else
                fake_yaw = 90
            end
        end
    elseif GetUi(menu_fakeyaw_ref) == "180" then
        fake_yaw = 0
    else
        fake_yaw = 0
    end
    
    if GetUi(menu_fakeyaw_ref) ~= "Off" then
        if GetUi(ui.yaw_jitter) == "Offset" then
            if offset_jitter == 0 then
                timer(1, function()
                    SetUi(menu_fakeyaw_offset_ref, fake_yaw)
                    offset_jitter = 1
                end)
                
            elseif offset_jitter == 1 then
                timer(1, function()
                    SetUi(menu_fakeyaw_offset_ref, GetUi(ui.yaw_jitter_slider))
                    offset_jitter = 0
                end)
            end
            
        elseif GetUi(ui.yaw_jitter) == "Center" then
            
            if center_jitter == 0 then
                timer(1, function()
                    SetUi(menu_fakeyaw_offset_ref, clamp(-180, 180, fake_yaw + GetUi(ui.yaw_jitter_slider)))
                    center_jitter = 1
                end)
                
            elseif center_jitter == 1 then
                timer(1, function()
                    SetUi(menu_fakeyaw_offset_ref, clamp(-180, 180, fake_yaw + (-GetUi(ui.yaw_jitter_slider))))
                    center_jitter = 0
                end)
            end
            
        elseif GetUi(ui.yaw_jitter) == "Random" then
            if IsNumberNegative(GetUi(ui.yaw_jitter_slider)) then
                local jitter = client.random_int(GetUi(ui.yaw_jitter_slider), (GetUi(ui.yaw_jitter_slider) - GetUi(ui.yaw_jitter_slider) - GetUi(ui.yaw_jitter_slider)))
                SetUi(menu_fakeyaw_offset_ref, clamp(-180, 180, fake_yaw + jitter))
            else
                local jitter = client.random_int(-GetUi(ui.yaw_jitter_slider), GetUi(ui.yaw_jitter_slider))
                SetUi(menu_fakeyaw_offset_ref, clamp(-180, 180, fake_yaw + jitter))
            end
            
        end
    else
        
    end
    
end)
