local weapon_materials = {
    -- [Weapon index] = path to material
	[1] = " ", -- DesertEagle
	[2] = " ", -- Elites
	[3] = " ", -- FiveSeven
	[4] = " ", -- Glock18
	[7] = " ", -- AK47
	[8] = " ", -- Aug
	[9] = " ", -- AWP
	[10] = " ", -- Famas
	[11] = " ", -- G3SG1
	[13] = " ", -- GalilAR
	[14] = " ", -- M249
	[16] = " ", -- M4A1
	[17] = " ", -- MAC10
	[19] = " ", -- P90
	[23] = " ", -- MP5SD
	[24] = " ", -- UMP45
	[25] = " ", -- xm1014
	[26] = " ", -- Bizon
	[27] = " ", -- Mag7
	[28] = " ", -- Negev
	[29] = " ", -- Sawedoff
	[30] = " ", -- Tec9
	[31] = " ", -- Taser
	[61] = " ", -- USP_SILENCER
	[33] = " ", -- MP7
	[34] = " ", -- MP9
	[35] = " ", -- Nova
	[36] = " ", -- P250
	[37] = " ", -- Shield
	[38] = " ", -- SCAR20
	[39] = " ", -- SG556
	[40] = " ", -- SSG08
	[41] = " ", -- Knife
	[42] = " ", -- Knife
	[43] = " ", -- FLASHBANG
	[44] = " ", -- HE_Grenade
	[45] = " ", -- Smoke_Grenade
	[46] = " ", -- MOLOTOV
	[47] = " ", -- DECOY
	[48] = " ", -- IncGrenade
	[49] = " ", -- C4
	[57] = " ", -- Healthshot
	[59] = " ", -- Knife_T
	[60] = " ", -- M4_SILENCER
	[61] = " ", -- USP_SILENCER
	[63] = " ", -- CZ75
	[64] = " ", -- REVOLVER
	[68] = " ", -- TAGrenade
	[70] = " ", -- BreachCharge
	[72] = " ", -- Tablet
	[74] = " ", -- Knife
	[75] = " ", -- Axe
	[76] = " ", -- Hammer
	[78] = " ", -- Spanner
	[80] = " ", -- Knife_Ghost
	[81] = " ", -- FIREBOMB
	[82] = " ", -- Diversion
	[83] = " ", -- frag_Grenade
	[84] = " ", -- Snowball
	[85] = " ", -- BUMPMINE
	[500] = " ", -- KnifeBayonet
	[503] = " ", -- KnifeCSS
	[505] = " ", -- KnifeFlip
	[506] = " ", -- KnifeGut
	[507] = " ", -- KnifeKaram
	[508] = " ", -- KnifeM9
	[509] = " ", -- KnifeTactical
	[512] = " ", -- knife_falchion_advanced
	[514] = " ", -- knife_survival_bowie
	[515] = " ", -- Knife_Butterfly
	[516] = " ", -- knife_push
	[519] = " ", -- knife_ursus
	[520] = " ", -- knife_gypsy_jackknife
	[522] = " ", -- knife_stiletto
	[521] = " ", -- knife_outdoor
	[507] = " ", -- KnifeKaram
	[525] = " ", -- knife_skeleton
	[518] = " ", -- knife_canis
	[517] = " ", -- knife_cord
	[523] = " ", -- knife_widowmaker
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
