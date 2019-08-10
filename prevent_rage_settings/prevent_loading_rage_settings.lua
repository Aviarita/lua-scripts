local SetUi = ui.set
local GetUi = ui.get
local aimbot = ui.reference("RAGE", "Aimbot", "Enabled")
local spread = ui.reference("RAGE", "Other", "Remove spread")
local recoil = ui.reference("RAGE", "Other", "Remove recoil")
local pitch = ui.reference("AA", "Anti-Aimbot angles", "Pitch")
local yaw = ui.reference("AA", "Anti-Aimbot angles", "Yaw")
local bodyyaw = ui.reference("AA", "Anti-Aimbot angles", "Body yaw")
local lby = ui.reference("AA", "Anti-Aimbot angles", "Lower body yaw target")
local anti_ut = ui.reference("MISC", "Settings", "Anti-untrusted")

local checkbox = ui.new_checkbox("MISC", "Other", "Prevent loading rage settings")

local GetAll = entity.get_all
local GetProp = entity.get_prop

local AddEvent = client.set_event_callback

AddEvent("run_command", function()
    local CCSGameRulesProxy = GetAll("CCSGameRulesProxy")[1]
    local m_bIsValveDS = GetProp(CCSGameRulesProxy, "m_bIsValveDS")
    
    if m_bIsValveDS == 1 and ui.get(checkbox) == true then
        SetUi(aimbot, false)
        SetUi(spread, false)
        SetUi(recoil, false)
        SetUi(pitch, "Off")
        SetUi(yaw, "Off")
        SetUi(lby, "Off")
        SetUi(fakeyaw, "Off")
        SetUi(anti_ut, true)
    end
end)
