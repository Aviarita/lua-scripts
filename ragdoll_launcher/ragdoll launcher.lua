local enabled = ui.new_checkbox("misc", "miscellaneous", "Ragdoll launcher")
local min = ui.new_slider("misc", "miscellaneous", "Radgoll launcher min", -100, 100, 0)
local max = ui.new_slider("misc", "miscellaneous", "Radgoll launcher max", -100, 100, 0)
client.set_event_callback("net_update_end", function()
    if ui.get(enabled) == false then return end
    local ragdolls = entity.get_all("CCSRagdoll")
    for i=1, #ragdolls do 
        local ragdoll = ragdolls[i]

        local mult = client.random_int(ui.get(min), ui.get(max))

        local force_x, force_y, force_z = entity.get_prop(ragdoll, "m_vecForce")
        local ragdollvelocity_x, ragdollvelocity_y, ragdollvelocity_z = entity.get_prop(ragdoll, "m_vecRagdollVelocity")

        entity.set_prop(ragdoll, "m_vecForce", force_x * mult, force_y * mult, force_z * mult)
        entity.set_prop(ragdoll, "m_vecRagdollVelocity", ragdollvelocity_x * mult, ragdollvelocity_y * mult, ragdollvelocity_z * mult)
    end
end)

ui.set_visible(min, ui.get(enabled))
ui.set_visible(max, ui.get(enabled))
ui.set_callback(enabled, function(self)
    ui.set_visible(min, ui.get(self))
    ui.set_visible(max, ui.get(self))
end)
