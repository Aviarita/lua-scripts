local weapon_materials = {
    -- [Weapon index] = path to material
	[1] = " ", -- weapon_deagle
	[2] = " ", -- weapon_elite
	[3] = " ", -- weapon_fiveseven
	[4] = " ", -- weapon_glock
	[7] = " ", -- weapon_ak47
	[8] = " ", -- weapon_aug
	[9] = " ", -- weapon_awp
	[10] = " ", -- weapon_famas
	[11] = " ", -- weapon_g3sg1
	[13] = " ", -- weapon_galilar
	[14] = " ", -- weapon_m249
	[16] = " ", -- weapon_m4a1
	[17] = " ", -- weapon_mac10
	[19] = " ", -- weapon_p90
	[23] = " ", -- weapon_mp7
	[24] = " ", -- weapon_ump45
	[25] = " ", -- weapon_xm1014
	[26] = " ", -- weapon_bizon
	[27] = " ", -- weapon_mag7
	[28] = " ", -- weapon_negev
	[29] = " ", -- weapon_sawedoff
	[30] = " ", -- weapon_tec9
	[31] = " ", -- weapon_taser
	[32] = " ", -- weapon_hkp2000
	[33] = " ", -- weapon_mp7
	[34] = " ", -- weapon_mp9
	[35] = " ", -- weapon_nova
	[36] = " ", -- weapon_p250
	[37] = " ", -- weapon_shield
	[38] = " ", -- weapon_scar20
	[39] = " ", -- weapon_sg556
	[40] = " ", -- weapon_ssg08
	[41] = " ", -- weapon_knifegg
	[42] = " ", -- weapon_knife
	[43] = " ", -- weapon_flashbang
	[44] = " ", -- weapon_hegrenade
	[45] = " ", -- weapon_smokegrenade
	[46] = " ", -- weapon_molotov
	[47] = " ", -- weapon_decoy
	[48] = " ", -- weapon_incgrenade
	[49] = " ", -- weapon_c4
	[57] = " ", -- weapon_healthshot
	[59] = " ", -- weapon_knife
	[60] = " ", -- weapon_m4a1
	[61] = " ", -- weapon_hkp2000
	[63] = " ", -- weapon_p250
	[64] = " ", -- weapon_deagle
	[68] = " ", -- weapon_tagrenade
	[70] = " ", -- weapon_breachcharge
	[72] = " ", -- weapon_tablet
	[74] = " ", -- weapon_melee
	[75] = " ", -- weapon_melee
	[76] = " ", -- weapon_melee
	[78] = " ", -- weapon_melee
	[80] = " ", -- weapon_knife
	[81] = " ", -- weapon_molotov
	[82] = " ", -- weapon_decoy
	[83] = " ", -- weapon_hegrenade
	[84] = " ", -- weapon_snowball
	[85] = " ", -- weapon_bumpmine
	[500] = " ", -- weapon_knife
	[503] = " ", -- weapon_knife
	[505] = " ", -- weapon_knife
	[506] = " ", -- weapon_knife
	[507] = " ", -- weapon_knife
	[508] = " ", -- weapon_knife
	[509] = " ", -- weapon_knife
	[512] = " ", -- weapon_knife
	[514] = " ", -- weapon_knife
	[515] = " ", -- weapon_knife
	[516] = " ", -- weapon_knife
	[519] = " ", -- weapon_knife
	[520] = " ", -- weapon_knife
	[522] = " ", -- weapon_knife
	[521] = " ", -- weapon_knife
	[525] = " ", -- weapon_knife
	[518] = " ", -- weapon_knife
	[517] = " ", -- weapon_knife
    [523] = " ", -- weapon_knife
}

local weapon_mats = {}
for k,v in pairs(weapon_materials) do
    table.insert(weapon_mats, k)
end

local replace_weapon_mats = ui.new_checkbox("lua", "a", "Replace weapon materials")

local function replace_material(ent, material)
    if material:len() > 5 and ent ~= nil then 
        local mats = materialsystem.get_model_materials(ent)
        local new_mat = materialsystem.find_material(material, true) or error("invalid material provided")
        new_mat:alpha_modulate(255)
        for i=1, #mats do 
            local mat = mats[i]
            local name = mat:get_name()
            if name:find("weapons/v_models") and not name:find("bare_") then 
                materialsystem.override_material(mat, new_mat)
            end
        end
    end
end

client.set_event_callback("net_update_start", function()
    if ui.get(replace_weapon_mats) then 

        local me = entity.get_local_player()
        if me == nil then return end

        if not entity.is_alive(me) then return end

        local m_hViewModel = entity.get_prop(me, "m_hViewModel[0]")
        if m_hViewModel == nil then return end
    
        local m_hWeapon = entity.get_prop(m_hViewModel, "m_hWeapon")
        if m_hWeapon == nil then return end
        
        if entity.get_prop(m_hWeapon, "m_iItemDefinitionIndex") == nil then return end
        local wpn_idx = bit.band(entity.get_prop(m_hWeapon, "m_iItemDefinitionIndex"), 0xFFFF)
        if wpn_idx == nil then return end

        if weapon_materials[wpn_idx] ~= nil then 
			replace_material(m_hViewModel, weapon_materials[wpn_idx])
        end
	end
end)
