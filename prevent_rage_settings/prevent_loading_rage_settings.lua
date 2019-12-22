local SetUi = ui.set
local GetUi = ui.get
local aimbot = ui.reference("RAGE", "Aimbot", "Enabled")
local spread = ui.reference("RAGE", "Other", "Remove spread")
local recoil = ui.reference("RAGE", "Other", "Remove recoil")
local antiaim = ui.reference("AA", "Anti-Aimbot angles", "Enabled")
local anti_ut = ui.reference("MISC", "Settings", "Anti-untrusted")

local checkbox = ui.new_checkbox("MISC", "Settings", "Prevent loading rage settings")

local GetAll = entity.get_all
local GetProp = entity.get_prop
client.set_event_callback("run_command", function()
    local CCSGameRulesProxy = GetAll("CCSGameRulesProxy")[1]
    local m_bIsValveDS = GetProp(CCSGameRulesProxy, "m_bIsValveDS")    
    if m_bIsValveDS == 1 and ui.get(checkbox) == true then
        SetUi(aimbot, false)
        SetUi(spread, false)
        SetUi(recoil, false)
        SetUi(antiaim, false)
        SetUi(anti_ut, true)
    end
end)
