--[[
credits: 
    https://www.unknowncheats.me/forum/counterstrike-global-offensive/310708-danger-zone-bypass-radar-jammer-healthshot-visuals-removal.html
]]
local activated = ui.new_checkbox("visuals", "effects", "Disabled tablet jammer")
local getprop, setprop, getall, me = entity.get_prop, entity.set_prop, entity.get_all, entity.get_local_player
client.set_event_callback("run_command", function()
    local tablets = getall("CTablet")
    for i=1, #tablets do 
        local tablet = tablets[i]
        local m_hOwner = getprop(tablet, "m_hOwner")
        if m_hOwner == me() then
            setprop(tablet, "m_bTabletReceptionIsBlocked", not ui.get(activated))
        end
    end
end)
