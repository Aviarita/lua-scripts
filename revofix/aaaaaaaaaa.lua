local ui_reference = ui.reference
local twist = ui.new_checkbox("AA", "Anti-aimbot angles", "Twist(Useless)")
local twist = ui.new_checkbox("RAGE", "Aimbot", "Stomach hitbox scale(Useless)")
function ui.reference(tab, container, name)
    if name == "Infinite duck" then 
        return ui_reference("misc", "movement", "Infinite duck")
    elseif name == "Twist" then 
        return twist
    elseif name == "Stomach hitbox scale" then 
        return shs        
    end
    return ui_reference(tab, container, name)
end
