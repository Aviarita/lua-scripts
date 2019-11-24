local ui_reference = ui.reference
local twist = ui.new_checkbox("AA", "Anti-aimbot angles", "Twist(Useless)")
local shs = ui.new_checkbox("RAGE", "Aimbot", "Stomach hitbox scale(Useless)")
local psp = ui_reference("RAGE", "Aimbot", "Prefer safe point")
local fsp = ui_reference("RAGE", "Aimbot", "Force safe point")
function ui.reference(tab, container, name)
    if name == "Infinite duck" then 
        return ui_reference("misc", "movement", "Infinite duck")
    elseif name == "Twist" then 
        return twist
    elseif name == "Stomach hitbox scale" then 
        return shs      
    elseif name == "Safe point" then 
        return psp, fsp   
    end
    return ui_reference(tab, container, name)
end
