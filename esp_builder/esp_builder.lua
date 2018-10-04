require("libs/Vector3D")

local GetUi = ui.get
local SetUi = ui.set
local NewSlider = ui.new_slider
local NewCheckbox = ui.new_checkbox
local NewCombo = ui.new_combobox
local NewColor = ui.new_color_picker
local NewMultiselect = ui.new_multiselect
local NewRef = ui.reference
local SetVisible = ui.set_visible
local SetCallback = ui.set_callback

local GetLocalPlayer = entity.get_local_player
local GetAll = entity.get_all
local GetProp = entity.get_prop
local SetProp = entity.set_prop
local GetHitboxPos = entity.hitbox_position
local GetPlayerName = entity.get_player_name
local GetWeapon = entity.get_player_weapon
local GetClass = entity.get_classname

local Log = client.log

local AddEvent = client.set_event_callback

local table_maxn, table_foreach, table_sort, table_remove, table_foreachi, table_move, table_getn, table_concat, table_insert = table.maxn, table.foreach, table.sort, table.remove, table.foreachi, table.move, table.getn, table.concat, table.insert

local MaxPlayers = globals.maxplayers()

local GetBoundingBox = entity.get_bounding_box

local DrawText = client.draw_text
local DrawRect = client.draw_rectangle
local DrawGradient = client.draw_gradient
local DrawLine = client.draw_line

local vsls = "visuals"
local otesp = "other esp"
local plesp = "player esp"

local teammate_ref = NewRef(vsls, plesp, "teammates")
local out_of_fov_ref_cb = NewRef(vsls, plesp, "out of fov arrow")
local bounding_box, bounding_box_color = NewRef(vsls, plesp, "bounding box")
local health_bar = NewRef(vsls, plesp, "health bar")
local name, name_color = NewRef(vsls, plesp, "name")
local weapon_text = NewRef(vsls, plesp, "weapon text")
local distance = NewRef(vsls, plesp, "distance")

local flags_ref = NewRef(vsls, plesp, "flags")
local ammo_ref, ammo_ref_color_ref = NewRef(vsls, plesp, "ammo")
local weapon_icon_ref, weapon_icon_color_ref = NewRef(vsls, plesp, "weapon icon")
local lby_timer_ref = NewRef(vsls, plesp, "lby timer")
local activation_type_ref = NewRef(vsls, plesp, "activation type")

local esp_builder_checkbox = NewCheckbox(vsls, plesp, "ESP Builder")
local teammates_checkbox = NewCheckbox(vsls, plesp, "Teammates")
local teammates_color = NewColor(vsls, plesp, "Teammates")

local box_esp_modes = {
    "None",
    "2D",
    "3D",
    "Pentagon",
    "Hexagon"
}
local box_mode_combo = NewCombo(vsls, plesp, "Bounding Box", box_esp_modes)
local box_color = NewColor(vsls, plesp, "Bounding Box", 255, 255, 255, 200)
local box_invis_cb = NewCheckbox(vsls, plesp, "Player behind wall(Box)")
local box_invis_color = NewColor(vsls, plesp, "Player behind wall(Box)", 255, 255, 255, 200)
local corner_width = NewSlider(vsls, plesp, "Corner Width", 0, 100, 100, true, "%")
local corner_height = NewSlider(vsls, plesp, "Corner Height", 0, 100, 100, true, "%")
local fill_cb = NewCheckbox(vsls, plesp, "Fill")
local fill_color = NewColor(vsls, plesp, "Fill", 255, 255, 255, 125)
local fill_invis_cb = NewCheckbox(vsls, plesp, "Player behind wall(Fill)")
local fill_invis_color = NewColor(vsls, plesp, "Player behind wall(Fill)", 255, 255, 255, 255)

local healthbar_pos = {
    "Top",
    "Right",
    "Bottom",
    "Left",
    "Text",
    "Gradient",
    "Battery"
}
local healthbar_mode_multi = NewMultiselect(vsls, plesp, "Health bar", healthbar_pos)
local healthbar_invis_cb = NewCheckbox(vsls, plesp, "Player behind wall(Health bar)")

local ammo_bar_pos = {
    "Top",
    "Right",
    "Bottom",
    "Left",
    "Text",
    "Gradient",
    "Battery"
}
local ammo_bar_mode_multi = NewMultiselect(vsls, plesp, "Ammo", ammo_bar_pos)
local ammo_bar_color = NewColor(vsls, plesp, "Ammo", 80, 140, 200, 255)
local ammo_bar_invis_cb = NewCheckbox(vsls, plesp, "Player behind wall(Ammo)")
local ammo_bar_invis_color = NewColor(vsls, plesp, "Player behind wall(Ammo)", 80, 140, 200, 255)

local name_pos = {
    "Top",
    "Right(Top)",
    "Right(Bottom)",
    "Bottom",
    "Left(Top)",
    "Left(Bottom)"
}
local name_esp_multi = NewMultiselect(vsls, plesp, "Name", name_pos)
local name_esp_color = NewColor(vsls, plesp, "Name", 255, 255, 255, 255)
local name_esp_invis_cb = NewCheckbox(vsls, plesp, "Player behind wall(Name)")
local name_esp_invis_color = NewColor(vsls, plesp, "Player behind wall(Name)", 255, 255, 255, 255)
local name_font = {
    "Normal",
    "Bold"
}
local name_font_combo = NewCombo(vsls, plesp, "Name Font", name_font)

local weapon_pos = {
    "Top",
    "Right(Top)",
    "Right(Bottom)",
    "Bottom",
    "Left(Top)",
    "Left(Bottom)"
}
local weapon_esp_multi = NewMultiselect(vsls, plesp, "Weapon", weapon_pos)
local weapon_esp_color = NewColor(vsls, plesp, "Weapon", 255, 255, 255, 255)
local weapon_esp_invis_cb = NewCheckbox(vsls, plesp, "Player behind wall(Weapon)")
local weapon_esp_invis_color = NewColor(vsls, plesp, "Player behind wall(Weapon)", 255, 255, 255, 255)
local weapon_font = {
    "Normal",
    "Bold",
    "Small"
}
local weapon_font_combo = NewCombo(vsls, plesp, "Weapon Font", weapon_font)

local distance_pos = {
    "Top",
    "Right(Top)",
    "Right(Bottom)",
    "Bottom",
    "Left(Top)",
    "Left(Bottom)"
}
local distance_esp_multi = NewMultiselect(vsls, plesp, "Distance", distance_pos)
local distance_esp_color = NewColor(vsls, plesp, "Distance", 255, 255, 255, 255)
local distance_esp_invis_cb = NewCheckbox(vsls, plesp, "Player behind wall(Distance)")
local distance_esp_invis_color = NewColor(vsls, plesp, "Player behind wall(Distance)", 255, 255, 255, 255)
local distance_mode = {
    "Feet",
    "Meter",
    "Units"
}
local distance_mode_combo = NewCombo(vsls, plesp, "Distance Mode", distance_mode)
local distance_font = {
    "Normal",
    "Bold",
    "Small"
}
local distance_font_combo = NewCombo(vsls, plesp, "Distance Font", distance_font)

function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

local function GetDistanceInMeter(a_x, a_y, a_z, b_x, b_y, b_z)
    return math.ceil(math.sqrt(math.pow(a_x - b_x, 2) + math.pow(a_y - b_y, 2) + math.pow(a_z - b_z, 2)) * 0.0254) .. "m"
end
local function GetDistanceInFeet(a_x, a_y, a_z, b_x, b_y, b_z)
    return math.ceil(math.sqrt(math.pow(a_x - b_x, 2) + math.pow(a_y - b_y, 2) + math.pow(a_z - b_z, 2)) * 0.0254 / 0.3048) .. "ft"
end
local function GetDistanceInUnits(a_x, a_y, a_z, b_x, b_y, b_z)
    return math.ceil(math.sqrt(math.pow(a_x - b_x, 2) + math.pow(a_y - b_y, 2) + math.pow(a_z - b_z, 2))) .. " units"
end

local function m_iTeamNum(entity_index)
    return GetProp(entity_index, "m_iTeamNum")
end

local function clamp(min, max, current)
    if current > max then
        current = max
    elseif current < min then
        current = min
    end
    return math.floor(current)
end

local function is_misc_weapon(entindex)
    local weapon_id = GetProp(entity_index, "m_hActiveWeapon")
    local weapon_item_index = GetProp(weapon_id, "m_iItemDefinitionIndex")
    
    if weapon_item_index == 42 then -- knife(ct)
        return true
        
    elseif weapon_item_index == 43 then -- flashbang
        return true
        
    elseif weapon_item_index == 44 then -- he
        return true
        
    elseif weapon_item_index == 45 then -- smoke
        return true
        
    elseif weapon_item_index == 46 then -- molotov
        return true
        
    elseif weapon_item_index == 47 then -- decoy
        return true
        
    elseif weapon_item_index == 48 then -- incendiary
        return true
        
    elseif weapon_item_index == 49 then -- bomb
        return true
        
    elseif weapon_item_index == 500 then -- bayonet
        return true
        
    elseif weapon_item_index == 505 then -- flip
        return true
        
    elseif weapon_item_index == 506 then -- gut
        return true
        
    elseif weapon_item_index == 507 then -- karambit
        return true
        
    elseif weapon_item_index == 508 then -- m9 bayonet
        return true
        
    elseif weapon_item_index == 509 then -- huntsman
        return true
        
    elseif weapon_item_index == 512 then -- falchion
        return true
        
    elseif weapon_item_index == 514 then -- bowie
        return true
        
    elseif weapon_item_index == 515 then -- butterfly
        return true
        
    elseif weapon_item_index == 516 then -- shadow daggers
        return true
        
    elseif weapon_item_index == 519 then -- ursus
        return true
        
    elseif weapon_item_index == 520 then -- navaja
        return true
        
    elseif weapon_item_index == 521 then -- UNKNOWN
        return true
        
    elseif weapon_item_index == 522 then -- siletto
        return true
        
    elseif weapon_item_index == 523 then -- talon
        return true
        
    else
        return false
    end
    
    -- return false
end

local function get_max_ammo(entity_index)
    local max_ammo = nil
    local weapon_id = GetProp(entity_index, "m_hActiveWeapon")
    local weapon_item_index = GetProp(weapon_id, "m_iItemDefinitionIndex")
    
    if weapon_item_index == 1 or weapon_item_index == 589825 then -- deagle
        
        max_ammo = 7
        
    elseif weapon_item_index == 2 then -- dual barettas
        
        max_ammo = 30
        
    elseif weapon_item_index == 3 then -- 5-7
        
        max_ammo = 20
        
    elseif weapon_item_index == 4 then -- glock
        
        max_ammo = 20
        
    elseif weapon_item_index == 7 then -- ak
        
        max_ammo = 30
        
    elseif weapon_item_index == 8 then -- aug
        
        max_ammo = 30
        
    elseif weapon_item_index == 9 then -- awp
        
        max_ammo = 10
        
    elseif weapon_item_index == 10 then -- famas
        
        max_ammo = 25
        
    elseif weapon_item_index == 11 then -- g3sg1
        
        max_ammo = 20
        
    elseif weapon_item_index == 13 then -- galil
        
        max_ammo = 35
        
    elseif weapon_item_index == 14 then -- m249
        
        max_ammo = 100
        
    elseif weapon_item_index == 16 then -- m4a4
        
        max_ammo = 30
        
    elseif weapon_item_index == 17 then -- mac 10
        
        max_ammo = 30
        
    elseif weapon_item_index == 19 then -- p90
        
        max_ammo = 50
        
    elseif weapon_item_index == 24 then -- ump
        
        max_ammo = 25
        
    elseif weapon_item_index == 25 then -- xm1014
        
        max_ammo = 7
        
    elseif weapon_item_index == 26 then -- bizon
        
        max_ammo = 64
        
    elseif weapon_item_index == 27 then -- mag7
        
        max_ammo = 5
        
    elseif weapon_item_index == 28 then -- negev
        
        max_ammo = 150
        
    elseif weapon_item_index == 29 then -- sawed off
        
        max_ammo = 7
        
    elseif weapon_item_index == 30 then -- tec 9
        
        max_ammo = 18
        
    elseif weapon_item_index == 32 then -- p2000
        
        max_ammo = 13
        
    elseif weapon_item_index == 33 then -- mp7
        
        max_ammo = 30
        
    elseif weapon_item_index == 34 then -- mp9
        
        max_ammo = 30
        
    elseif weapon_item_index == 35 then -- nova
        
        max_ammo = 8
        
    elseif weapon_item_index == 36 then -- p250
        
        max_ammo = 13
        
    elseif weapon_item_index == 38 then -- scar 20
        
        max_ammo = 20
        
    elseif weapon_item_index == 39 then -- sg553
        
        max_ammo = 30
        
    elseif weapon_item_index == 40 then -- scout
        
        max_ammo = 10
        
    elseif weapon_item_index == 60 then -- m4a1s
        
        max_ammo = 20
        
    elseif weapon_item_index == 61 then -- usps
        
        max_ammo = 12
        
    elseif weapon_item_index == 63 then -- cz
        
        max_ammo = 12
        
    elseif weapon_item_index == 64 then -- revolvo
        
        max_ammo = 8
    else
        max_ammo = nil
    end
    return max_ammo
end

local weaponids = {
    CDEagle = "Desert Eagle/R8",
    CWeaponElite = "Dual Berettas",
    CWeaponFiveSeven = "Five-SeveN",
    CWeaponGlock = "Glock-18",
    CAK47 = "AK-47",
    CWeaponAug = "AUG",
    CWeaponAWP = "AWP",
    CWeaponFamas = "FAMAS",
    CWeaponG3SG1 = "G3SG1",
    CWeaponGalilAR = "Galil AR",
    CWeaponM249 = "M249",
    CWeaponM4A1 = "M4",
    CWeaponMAC10 = "MAC-10",
    CWeaponP90 = "P90",
    CWeaponUMP45 = "UMP-45",
    CWeaponXM1014 = "XM1014",
    CWeaponBizon = "PP-Bizon",
    CWeaponMag7 = "MAG-7",
    CWeaponNegev = "Negev",
    CWeaponSawedoff = "Sawed-Off",
    CWeaponTec9 = "Tec-9",
    CWeaponHKP2000 = "P2000/USP-S",
    CWeaponMP7 = "MP7/MP5",
    CWeaponMP9 = "MP9",
    CWeaponNOVA = "Nova",
    CWeaponP250 = "P250/CZ75",
    CWeaponSCAR20 = "SCAR-20",
    CWeaponSG553 = "SG 553",
    CWeaponSG556 = "SG 556",
    CWeaponSSG08 = "SSG 08",
    CWeaponTaser = "Taser",
    CKnife = "Knife",
    CHEGrenade = "HE",
    CSmokeGrenade = "Smoke",
    CDecoyGrenade = "Decoy",
    CFlashbang = "Flash",
    CIncendiaryGrenade = "Incendiary",
    CMolotovGrenade = "Molotov",
}

local function get_weapon_name(weapon)
    return weaponids[entity.get_classname(weapon)]
end

--credits to sapphyrus --
local function contains(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

local function can_see(ent2)
    local radius = 20
    
    ent2_x, ent2_y, ent2_z = GetProp(ent2, "m_vecOrigin")
    local voZ = GetProp(ent2, "m_vecViewOffset[2]")
    
    if client.visible(ent2_x, ent2_y, ent2_z) then
        return true
    end
    
    if client.visible(ent2_x, ent2_y, ent2_z + voZ) then
        return true
    end
    
    if client.visible(ent2_x, ent2_y, ent2_z + voZ / 2) then
        return true
    end
    
    if
        client.visible(ent2_x + radius, ent2_y, ent2_z + voZ / 2)
        or client.visible(ent2_x, ent2_y + radius, ent2_z + voZ / 2)
        or client.visible(ent2_x - radius, ent2_y, ent2_z + voZ / 2)
        or client.visible(ent2_x, ent2_y - radius, ent2_z + voZ / 2)
        or client.visible(ent2_x + radius, ent2_y + radius, ent2_z + voZ / 2)
        or client.visible(ent2_x + radius, ent2_y - radius, ent2_z + voZ / 2)
        or client.visible(ent2_x - radius, ent2_y + radius, ent2_z + voZ / 2)
        or client.visible(ent2_x - radius, ent2_y - radius, ent2_z + voZ / 2)
        then
        return true
    end
    
    if client.visible(ent2_x + radius, ent2_y, ent2_z)
        or client.visible(ent2_x, ent2_y + radius, ent2_z)
        or client.visible(ent2_x - radius, ent2_y, ent2_z)
        or client.visible(ent2_x, ent2_y - radius, ent2_z)
        then
        return true
    end
    
    if client.visible(ent2_x + radius, ent2_y, ent2_z + voZ + 8)
        or client.visible(ent2_x, ent2_y + radius, ent2_z + voZ + 8)
        or client.visible(ent2_x - radius, ent2_y, ent2_z + voZ + 8)
        or client.visible(ent2_x, ent2_y - radius, ent2_z + voZ + 8)
        then
        return true
    end
    
    return false
end

local function get_dormant_players(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    local result = {}
    
    local player_resource = GetAll("CCSPlayerResource")[1]
    
    for player = 1, globals.maxplayers() do
        if GetProp(player_resource, "m_bConnected", player) == 1 then
            local local_player_team
            if enemy_only then
                local_player_team = GetProp(GetLocalPlayer(), "m_iTeamNum")
            end
            
            local is_enemy = true
            if enemy_only and GetProp(player, "m_iTeamNum") == local_player_team then
                is_enemy = false
            end
            
            if player == GetLocalPlayer() then
                is_enemy = false
            end
            
            if is_enemy then
                local is_alive = true
                if alive_only and not entity.is_alive(player) then
                    is_alive = false
                end
                
                if is_alive then
                    table_insert(result, player)
                end
            end
        end
    end
    
    return result
end
-- credits end --

-- credits to nmchris
local function get_weapon(entindex)
    
    local current_weapon = nil
    local weapon_id = GetProp(entindex, "m_hActiveWeapon")
    local weapon_item_index = GetProp(weapon_id, "m_iItemDefinitionIndex")
    
    if weapon_item_index == 1 then
        current_weapon = "Desert Eagle"
        
    elseif weapon_item_index == 2 then
        current_weapon = "Dual Berettas"
        
    elseif weapon_item_index == 3 then
        current_weapon = "Five-SeveN"
        
    elseif weapon_item_index == 4 then
        current_weapon = "Glock-18"
        
    elseif weapon_item_index == 7 then
        current_weapon = "AK-47"
        
    elseif weapon_item_index == 8 then
        current_weapon = "AUG"
        
    elseif weapon_item_index == 9 then
        current_weapon = "AWP"
        
    elseif weapon_item_index == 10 then
        current_weapon = "FAMAS"
        
    elseif weapon_item_index == 11 then
        current_weapon = "G3SG1"
        
    elseif weapon_item_index == 13 then
        current_weapon = "Galil AR"
        
    elseif weapon_item_index == 14 then
        current_weapon = "M249"
        
    elseif weapon_item_index == 16 then
        current_weapon = "M4A4"
        
    elseif weapon_item_index == 17 then
        current_weapon = "MAC-10"
        
    elseif weapon_item_index == 19 then
        current_weapon = "P90"
        
    elseif weapon_item_index == 24 then
        current_weapon = "UMP-45"
        
    elseif weapon_item_index == 25 then
        current_weapon = "XM1014"
        
    elseif weapon_item_index == 26 then
        current_weapon = "PP-Bizon"
        
    elseif weapon_item_index == 27 then
        current_weapon = "MAG-7"
        
    elseif weapon_item_index == 28 then
        current_weapon = "Negev"
        
    elseif weapon_item_index == 29 then
        current_weapon = "Sawed-Off"
        
    elseif weapon_item_index == 30 then
        current_weapon = "Tec-9"
        
    elseif weapon_item_index == 32 then
        current_weapon = "P2000"
        
    elseif weapon_item_index == 33 then
        current_weapon = "MP7"
        
    elseif weapon_item_index == 34 then
        current_weapon = "MP9"
        
    elseif weapon_item_index == 35 then
        current_weapon = "Nova"
        
    elseif weapon_item_index == 36 then
        current_weapon = "P250"
        
    elseif weapon_item_index == 38 then
        current_weapon = "SCAR-20"
        
    elseif weapon_item_index == 39 then
        current_weapon = "SG 553"
        
    elseif weapon_item_index == 40 then
        current_weapon = "SSG 08"
        
    elseif weapon_item_index == 60 then
        current_weapon = "M4A1-S"
        
    elseif weapon_item_index == 61 then
        current_weapon = "USP-S"
        
    elseif weapon_item_index == 63 then
        current_weapon = "CZ75-Auto"
        
    elseif weapon_item_index == 64 then
        current_weapon = "R8 Revolver"
        
    elseif weapon_item_index == 42 then -- knife(ct)
        current_weapon = "Knife"
        
    elseif weapon_item_index == 43 then -- flashbang
        current_weapon = "Flash"
        
    elseif weapon_item_index == 44 then -- he
        current_weapon = "HE"
        
    elseif weapon_item_index == 45 then -- smoke
        current_weapon = "Smoke"
        
    elseif weapon_item_index == 46 then -- molotov
        current_weapon = "Molotov"
        
    elseif weapon_item_index == 47 then -- decoy
        current_weapon = "Decoy"
        
    elseif weapon_item_index == 48 then -- incendiary
        current_weapon = "Incendiary"
        
    elseif weapon_item_index == 49 then -- bomb
        current_weapon = "Bomb"
        
    elseif weapon_item_index == 500 then -- bayonet
        current_weapon = "Bayonet"
        
    elseif weapon_item_index == 505 then -- flip
        current_weapon = "Flip"
        
    elseif weapon_item_index == 506 then -- gut
        current_weapon = "Gut"
        
    elseif weapon_item_index == 507 then -- karambit
        current_weapon = "Karambit"
        
    elseif weapon_item_index == 508 then -- m9 bayonet
        current_weapon = "M9 Bayonet"
        
    elseif weapon_item_index == 509 then -- huntsman
        current_weapon = "Huntsman"
        
    elseif weapon_item_index == 512 then -- falchion
        current_weapon = "Falchion"
        
    elseif weapon_item_index == 514 then -- bowie
        current_weapon = "Bowie"
        
    elseif weapon_item_index == 515 then -- butterfly
        current_weapon = "Butterfly"
        
    elseif weapon_item_index == 516 then -- shadow daggers
        current_weapon = "Shadow Daggers"
        
    elseif weapon_item_index == 519 then -- ursus
        current_weapon = "Ursus"
        
    elseif weapon_item_index == 520 then -- navaja
        current_weapon = "Navaja"
        
    elseif weapon_item_index == 521 then -- UNKNOWN
        current_weapon = "Other"
        
    elseif weapon_item_index == 522 then -- siletto
        current_weapon = "Siletto"
        
    elseif weapon_item_index == 523 then -- talon
        current_weapon = "Talon"
        
    else
        current_weapon = "Other"
    end
    
    return current_weapon
end
-- credits end

local gbb = {
    topX, topY, botX, botY, alpha,
    width, height,
    middle_x, middle_y
}

local overall_height_addition_right = 0
local overall_height_addition_bottom = 0

AddEvent("paint", function()
    
    if GetUi(flags_ref) == true then
        overall_height_addition_right = 40
    else
        overall_height_addition_right = 0
    end
    
    local height_addition_table = {
        ["000"] = 0,
        ["100"] = 5,
        ["010"] = 5,
        ["001"] = 15,
        ["110"] = 10,
        ["101"] = 18,
        ["011"] = 18,
        ["111"] = 25
    }
    overall_height_addition_bottom = height_addition_table[(GetUi(ammo_ref) and 1 or 0) .. (GetUi(lby_timer_ref) and 1 or 0) .. (GetUi(weapon_icon_ref) and 1 or 0)] or 0
end)

local function DrawBoxEsp(ctx, entity_index)
    
    gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = GetBoundingBox(ctx, entity_index)
    
    if gbb.topX == nil or gbb.topY == nil or gbb.botX == nil or gbb.botY == nil or gbb.alpha == nil or gbb.alpha == 0 then return end
    
    gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    
    gbb.middle_x = (gbb.topX - gbb.botX) / 2
    gbb.middle_y = (gbb.topY - gbb.botY) / 2
    
    local is_visible = can_see(entity_index)
    
    local red, green, blue, alpha = GetUi(box_color)
    
    if not is_visible and GetUi(box_invis_cb) then
        red, green, blue, alpha = GetUi(box_invis_color)
    else
        red, green, blue, alpha = GetUi(box_color)
    end
    
    if not is_visible and GetUi(box_invis_cb) == false then
        return
    end
    
    alpha = alpha * gbb.alpha
    local alpha2 = 255 * gbb.alpha
    
    local W = (GetUi(corner_width) / 200)
    local H = (GetUi(corner_height) / 200)
    
    local fill_r, fill_g, fill_b, fill_alpha = 255, 255, 255, 125
    
    if not is_visible and GetUi(fill_invis_cb) then
        fill_r, fill_g, fill_b, fill_alpha = GetUi(fill_invis_color)
    else
        fill_r, fill_g, fill_b, fill_alpha = GetUi(fill_color)
    end
    
    fill_alpha = fill_alpha * gbb.alpha
    
    -- disgusting code but thats the best way i could think of to not have leftover pixels in the corners when corner_width and corner_height are 0
    
    -- Lines
    
    if W > 0 then
        DrawLine(ctx, gbb.topX + (gbb.width * W), gbb.topY, gbb.topX, gbb.topY, red, green, blue, alpha) -- Top left width
        
        DrawLine(ctx, gbb.botX - (gbb.width * W), gbb.topY, gbb.botX - 1, gbb.topY, red, green, blue, alpha) -- Top right width
        
        DrawLine(ctx, gbb.topX + (gbb.width * W), gbb.botY - 1, gbb.topX, gbb.botY - 1, red, green, blue, alpha)-- Bottom left width
        
        DrawLine(ctx, gbb.botX - (gbb.width * W), gbb.botY - 1, gbb.botX - 1, gbb.botY - 1, red, green, blue, alpha)-- Bottom right width
    end
    
    if H > 0 then
        DrawLine(ctx, gbb.topX, gbb.topY + (gbb.height * H), gbb.topX, gbb.topY, red, green, blue, alpha) -- Top left height
        
        DrawLine(ctx, gbb.botX - 1, gbb.topY + (gbb.height * H), gbb.botX - 1, gbb.topY, red, green, blue, alpha) -- Top right height
        
        DrawLine(ctx, gbb.topX, gbb.botY - (gbb.height * H), gbb.topX, gbb.botY - 1, red, green, blue, alpha)-- Bottom left height
        
        DrawLine(ctx, gbb.botX - 1, gbb.botY - 1, gbb.botX - 1, gbb.botY - (gbb.height * H), red, green, blue, alpha)-- Bottom right height
    end
    
    -- Outlines
    
    if W > 0 then
        DrawLine(ctx, gbb.topX + (gbb.width * W), gbb.topY + 1, gbb.topX + 1, gbb.topY + 1, 0, 0, 0, alpha2) -- Top left inner width
        DrawLine(ctx, gbb.topX + (gbb.width * W), gbb.topY - 1, gbb.topX - 1, gbb.topY - 1, 0, 0, 0, alpha2) -- Top left outer width
        
        DrawLine(ctx, gbb.botX - (gbb.width * W), gbb.topY + 1, gbb.botX - 2, gbb.topY + 1, 0, 0, 0, alpha2) -- Top right inner width
        DrawLine(ctx, gbb.botX - (gbb.width * W), gbb.topY - 1, gbb.botX, gbb.topY - 1, 0, 0, 0, alpha2) -- Top right outer width
        
        DrawLine(ctx, gbb.topX + (gbb.width * W), gbb.botY - 2, gbb.topX + 1, gbb.botY - 2, 0, 0, 0, alpha2) -- Bottom left inner width
        DrawLine(ctx, gbb.topX + (gbb.width * W), gbb.botY, gbb.topX - 1, gbb.botY, 0, 0, 0, alpha2) -- Bottom left outer width
        
        DrawLine(ctx, gbb.botX - (gbb.width * W), gbb.botY - 2, gbb.botX - 2, gbb.botY - 2, 0, 0, 0, alpha2) -- Bottom right inner width
        DrawLine(ctx, gbb.botX - (gbb.width * W), gbb.botY, gbb.botX, gbb.botY, 0, 0, 0, alpha2) -- Bottom right outer width
    end
    
    if H > 0 then
        DrawLine(ctx, gbb.topX + 1, gbb.topY + (gbb.height * H), gbb.topX + 1, gbb.topY + 1, 0, 0, 0, alpha2) -- Top left inner height
        DrawLine(ctx, gbb.topX - 1, gbb.topY + (gbb.height * H), gbb.topX - 1, gbb.topY - 1, 0, 0, 0, alpha2) -- Top left outer height
        
        DrawLine(ctx, gbb.botX - 2, gbb.topY + (gbb.height * H), gbb.botX - 2, gbb.topY + 1, 0, 0, 0, alpha2) -- Top right inner height
        DrawLine(ctx, gbb.botX, gbb.topY + (gbb.height * H), gbb.botX, gbb.topY - 1, 0, 0, 0, alpha2) -- Top right outer height
        
        DrawLine(ctx, gbb.topX + 1, gbb.botY - (gbb.height * H), gbb.topX + 1, gbb.botY - 2, 0, 0, 0, alpha2) -- Bottom left inner height
        DrawLine(ctx, gbb.topX - 1, gbb.botY - (gbb.height * H), gbb.topX - 1, gbb.botY, 0, 0, 0, alpha2) -- Bottom left outer height
        
        DrawLine(ctx, gbb.botX - 2, gbb.botY - 2, gbb.botX - 2, gbb.botY - (gbb.height * H), 0, 0, 0, alpha2) -- Bottom right inner height
        DrawLine(ctx, gbb.botX, gbb.botY, gbb.botX, gbb.botY - (gbb.height * H), 0, 0, 0, alpha2) -- Bottom right outer height
    end
    
    if not is_visible and GetUi(fill_invis_cb) == false then
        return
    end
    
    -- Fill
    if GetUi(fill_cb) then
        DrawRect(ctx, gbb.topX + 2, gbb.botY + 2 - gbb.height, gbb.width - 4, gbb.height - 4, fill_r, fill_g, fill_b, fill_alpha)
    end
end

local function Draw3DEsp(ctx, entity_index)
    gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = GetBoundingBox(ctx, entity_index)
    
    if gbb.topX == nil or gbb.topY == nil or gbb.botX == nil or gbb.botY == nil or gbb.alpha == nil or gbb.alpha == 0 then return end
    
    gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    
    gbb.middle_x = (gbb.topX - gbb.botX) / 2
    gbb.middle_y = (gbb.topY - gbb.botY) / 2
    
    local is_visible = can_see(entity_index)
    
    local red, green, blue, alpha = GetUi(box_color)
    
    if not is_visible and GetUi(box_invis_cb) then
        red, green, blue, alpha = GetUi(box_invis_color)
    else
        red, green, blue, alpha = GetUi(box_color)
    end
    
    if not is_visible and GetUi(box_invis_cb) == false then
        return
    end
    
    alpha = alpha * gbb.alpha
    local alpha2 = 255 * gbb.alpha
    
    local origin = Vector3(GetProp(entity_index, "m_vecOrigin"))
    local collision = (GetProp(entity_index, "m_Collision"))
    local min = Vector3(GetProp(entity_index, "m_vecMins")) + origin
    local max = Vector3(GetProp(entity_index, "m_vecMaxs")) + origin
    
    local points =
    {
        Vector3(min.x, min.y, min.z),
        Vector3(min.x, max.y, min.z),
        Vector3(max.x, max.y, min.z),
        Vector3(max.x, min.y, min.z),
        Vector3(min.x, min.y, max.z),
        Vector3(min.x, max.y, max.z),
        Vector3(max.x, max.y, max.z),
        Vector3(max.x, min.y, max.z),
    }
    
    local edges = {
        {0, 1}, {1, 2}, {2, 3}, {3, 0},
        {5, 6}, {6, 7}, {1, 4}, {4, 8},
        {0, 4}, {1, 5}, {2, 6}, {3, 7},
    {5, 8}, {7, 8}, {3, 4}}
    
    for i = 1, #edges do
        if points[edges[i][1]] ~= nil and points[edges[i][2]] ~= nil then
            local p1 = Vector3(client.world_to_screen(ctx, points[edges[i][1]].x, points[edges[i][1]].y, points[edges[i][1]].z))
            local p2 = Vector3(client.world_to_screen(ctx, points[edges[i][2]].x, points[edges[i][2]].y, points[edges[i][2]].z))
            client.draw_line(ctx, p1.x, p1.y, p2.x, p2.y, red, green, blue, alpha)
            client.draw_line(ctx, p1.x + 1, p1.y + 1, p2.x + 1, p2.y + 1, 0, 0, 0, alpha2)
            client.draw_line(ctx, p1.x - 1, p1.y - 1, p2.x - 1, p2.y - 1, 0, 0, 0, alpha2)
        end
    end
end

local function DrawPentagonEsp(ctx, entity_index)
    gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = GetBoundingBox(ctx, entity_index)
    
    if gbb.topX == nil or gbb.topY == nil or gbb.botX == nil or gbb.botY == nil or gbb.alpha == nil or gbb.alpha == 0 then return end
    
    gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    
    gbb.middle_x = (gbb.botX - gbb.topX) --/ 2
    gbb.middle_y = (gbb.botY - gbb.topY) --/ 2
    
    local is_visible = can_see(entity_index)
    
    local red, green, blue, alpha = GetUi(box_color)
    
    if not is_visible and GetUi(box_invis_cb) then
        red, green, blue, alpha = GetUi(box_invis_color)
    else
        red, green, blue, alpha = GetUi(box_color)
    end
    
    if not is_visible and GetUi(box_invis_cb) == false then
        return
    end

    alpha = alpha * gbb.alpha
    local alpha2 = 255 * gbb.alpha

    -- Lines

    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.topY - (gbb.height / 8), gbb.topX - (gbb.width / 8), gbb.topY + (gbb.height / 3), red, green, blue, alpha)
    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.topY - (gbb.height / 8), gbb.topX + (gbb.width) + (gbb.width / 8), gbb.topY + (gbb.height / 3), red, green, blue, alpha)
    
    DrawLine(ctx, gbb.botX - (gbb.width - 10), gbb.topY + (gbb.height), gbb.topX - (gbb.width / 8), gbb.topY + (gbb.height / 3), red, green, blue, alpha)
    DrawLine(ctx, gbb.botX - 10, gbb.topY + (gbb.height), gbb.topX + (gbb.width) + (gbb.width / 8), gbb.topY + (gbb.height / 3), red, green, blue, alpha)
   
    DrawLine(ctx, gbb.topX + (gbb.width - 10), gbb.botY, gbb.botX + 10 - (gbb.width), gbb.botY, red, green, blue, alpha)

    -- Outlines

    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.topY - (gbb.height / 8) - 2, gbb.topX - (gbb.width / 8) - 1, gbb.topY + (gbb.height / 3), 0, 0, 0, alpha2)
    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.topY - (gbb.height / 8) - 2, gbb.topX + (gbb.width) + (gbb.width / 8) + 1, gbb.topY + (gbb.height / 3), 0, 0, 0, alpha2)
    
    DrawLine(ctx, gbb.botX - (gbb.width - 9), gbb.topY + (gbb.height) + 1, gbb.topX - (gbb.width / 8) - 1, gbb.topY + (gbb.height / 3), 0, 0, 0, alpha2)
    DrawLine(ctx, gbb.botX - 9, gbb.topY + (gbb.height) + 1, gbb.topX + (gbb.width) + (gbb.width / 8) + 1, gbb.topY + (gbb.height / 3), 0, 0, 0, alpha2)
    
    DrawLine(ctx, gbb.topX + (gbb.width - 9), gbb.botY + 1, gbb.botX + 9 - (gbb.width), gbb.botY + 1, 0, 0, 0, alpha2)

    -- Inlines

    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.topY - (gbb.height / 8) + 2, gbb.topX - (gbb.width / 8) + 2, gbb.topY + (gbb.height / 3), 0, 0, 0, alpha2)
    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.topY - (gbb.height / 8) + 2, gbb.topX + (gbb.width) + (gbb.width / 8) - 2, gbb.topY + (gbb.height / 3), 0, 0, 0, alpha2)
    
    DrawLine(ctx, gbb.botX - (gbb.width - 11), gbb.topY + (gbb.height) - 1, gbb.topX - (gbb.width / 8) + 2, gbb.topY + (gbb.height / 3) - 1, 0, 0, 0, alpha2)
    DrawLine(ctx, gbb.botX - 11, gbb.topY + (gbb.height) - 1, gbb.topX + (gbb.width) + (gbb.width / 8) - 2, gbb.topY + (gbb.height / 3) - 1, 0, 0, 0, alpha2)
    
    DrawLine(ctx, gbb.topX + (gbb.width - 11), gbb.botY - 1, gbb.botX + 11 - (gbb.width), gbb.botY - 1, 0, 0, 0, alpha2)
end
                   
local function DrawHexagonEsp(ctx, entity_index)
    gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = GetBoundingBox(ctx, entity_index)
    
    if gbb.topX == nil or gbb.topY == nil or gbb.botX == nil or gbb.botY == nil or gbb.alpha == nil or gbb.alpha == 0 then return end
    
    gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    
    gbb.middle_x = (gbb.topX - gbb.botX) / 2
    gbb.middle_y = (gbb.topY - gbb.botY) / 2
    
    local is_visible = can_see(entity_index)
    
    local red, green, blue, alpha = GetUi(box_color)

    if not is_visible and GetUi(box_invis_cb) then
        red, green, blue, alpha = GetUi(box_invis_color)
    else
        red, green, blue, alpha = GetUi(box_color)
    end
    
    if not is_visible and GetUi(box_invis_cb) == false then
        return
    end
    
    alpha = alpha * gbb.alpha
    local alpha2 = 255 * gbb.alpha
    
    -- Lines
    DrawLine(ctx, gbb.topX + (gbb.width / 2), gbb.topY - (gbb.height / 12), gbb.topX, gbb.topY + (gbb.height / 4), red, green, blue, alpha)
    DrawLine(ctx, gbb.topX + (gbb.width / 2), gbb.topY - (gbb.height / 12), gbb.topX + gbb.width - 1, gbb.topY + (gbb.height / 4), red, green, blue, alpha)

    DrawLine(ctx, gbb.topX, gbb.topY + (gbb.height / 4), gbb.botX - gbb.width, gbb.botY - (gbb.height / 4), red, green, blue, alpha)
    DrawLine(ctx, gbb.botX - 1, gbb.topY + (gbb.height / 4), gbb.botX - 1, gbb.botY - (gbb.height / 4), red, green, blue, alpha)

    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.botY + (gbb.height / 12), gbb.botX - gbb.width, gbb.botY - (gbb.height / 4), red, green, blue, alpha)
    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.botY + (gbb.height / 12), gbb.botX - 1, gbb.botY - (gbb.height / 4), red, green, blue, alpha)
    
    -- Outlines
    DrawLine(ctx, gbb.topX + (gbb.width / 2), gbb.topY - (gbb.height / 12) - 2, gbb.topX - 1, gbb.topY + (gbb.height / 4), 0, 0, 0, alpha2)
    DrawLine(ctx, gbb.topX + (gbb.width / 2), gbb.topY - (gbb.height / 12) - 2, gbb.topX + gbb.width, gbb.topY + (gbb.height / 4), 0, 0, 0, alpha2)

    DrawLine(ctx, gbb.topX - 1, gbb.topY + (gbb.height / 4) - 1, gbb.botX - gbb.width - 1, gbb.botY - (gbb.height / 4) + 1, 0, 0, 0, alpha2)
    DrawLine(ctx, gbb.botX, gbb.topY + (gbb.height / 4) - 1, gbb.botX, gbb.botY - (gbb.height / 4) + 1, 0, 0, 0, alpha2)

    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.botY + (gbb.height / 12) + 2, gbb.botX - gbb.width - 1, gbb.botY - (gbb.height / 4) + 1, 0, 0, 0, alpha2)
    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.botY + (gbb.height / 12) + 2, gbb.botX, gbb.botY - (gbb.height / 4) + 1, 0, 0, 0, alpha2)


    -- Inlines
    DrawLine(ctx, gbb.topX + (gbb.width / 2), gbb.topY - (gbb.height / 12) + 2, gbb.topX + 1, gbb.topY + (gbb.height / 4) + 1, 0, 0, 0, alpha2)
    DrawLine(ctx, gbb.topX + (gbb.width / 2), gbb.topY - (gbb.height / 12) + 2, gbb.topX + gbb.width - 2, gbb.topY + (gbb.height / 4) + 1, 0, 0, 0, alpha2)

    DrawLine(ctx, gbb.topX + 1, gbb.topY + (gbb.height / 4), gbb.botX - gbb.width + 1, gbb.botY - (gbb.height / 4) + 1, 0, 0, 0, alpha2)
    DrawLine(ctx, gbb.botX - 2, gbb.topY + (gbb.height / 4), gbb.botX - 2, gbb.botY - (gbb.height / 4), 0, 0, 0, alpha2)

    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.botY + (gbb.height / 12) - 2, gbb.botX - gbb.width, gbb.botY - (gbb.height / 4) - 1, 0, 0, 0, alpha2)
    DrawLine(ctx, gbb.botX - (gbb.width / 2), gbb.botY + (gbb.height / 12) - 2, gbb.botX - 2, gbb.botY - (gbb.height / 4), 0, 0, 0, alpha2)
end

local function DrawHealthbar(ctx, entity_index)
    
    gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = GetBoundingBox(ctx, entity_index)
    
    if gbb.topX == nil or gbb.topY == nil or gbb.botX == nil or gbb.botY == nil or gbb.alpha == nil or gbb.alpha == 0 then return end
    
    gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    
    gbb.middle_x = (gbb.topX - gbb.botX) / 2
    gbb.middle_y = (gbb.topY - gbb.botY) / 2
    
    local activation_type = GetUi(healthbar_mode_multi)
    
    local is_visible = can_see(entity_index)
    
    if not GetUi(healthbar_invis_cb) and not is_visible then
        return
    end
    
    local enemy_health = clamp(0, 100, GetProp(entity_index, "m_iHealth"))
    
    if enemy_health == 0 then return end
    
    local red = 255 - (enemy_health * 2.00);
    local green = enemy_health * 2.00;
    local alpha = 150 * gbb.alpha
    local alpha2 = 255 * gbb.alpha
    
    local health_width = (gbb.width * enemy_health) / 100
    local health_height = (gbb.height * enemy_health) / 100
    
    local text_enabled = contains(activation_type, "Text") and enemy_health < 100
    
    if contains(activation_type, "Top") then
        
        DrawLine(ctx, gbb.topX - 1, gbb.topY - 7, gbb.topX + gbb.width, gbb.topY - 7, 0, 0, 0, alpha2) -- Top line
        DrawLine(ctx, gbb.topX - 1, gbb.topY - 4, gbb.topX - 1, gbb.topY - 7, 0, 0, 0, alpha2) -- Left line
        
        DrawRect(ctx, gbb.topX - 1, gbb.topY - 7, gbb.width + 1, 4, 0, 0, 0, alpha) -- Background
        
        DrawLine(ctx, gbb.topX - 1, gbb.topY - 4, gbb.topX + gbb.width, gbb.topY - 4, 0, 0, 0, alpha2) -- Bottom line
        DrawLine(ctx, gbb.topX + gbb.width, gbb.topY - 4, gbb.topX + gbb.width, gbb.topY - 7, 0, 0, 0, alpha2) -- Right line
        
        if contains(activation_type, "Gradient") then
            DrawGradient(ctx, gbb.topX, gbb.topY - 6, health_width, 2, red, green, 0, alpha2, 0, 0, 0, alpha2, false)
        else
            DrawRect(ctx, gbb.topX, gbb.topY - 6, health_width, 2, red, green, 0, alpha2) -- Health
        end
        
        if contains(activation_type, "Battery") then
            for i = 1, 9, 1 do
                DrawLine(ctx, gbb.topX + i * (gbb.width / 10), gbb.topY - 4, gbb.topX + i * (gbb.width / 10), gbb.topY - 7, 0, 0, 0, alpha2) -- Left line
            end
        end
        
        if text_enabled then
            DrawText(ctx, gbb.topX + health_width - 4, gbb.topY - 10, 255, 255, 255, alpha, "-", 999, enemy_health)
        end
    end
    
    if contains(activation_type, "Right") then
        
        DrawLine(ctx, gbb.botX + 3, gbb.topY - 1, gbb.topX + gbb.width + 6, gbb.topY - 1, 0, 0, 0, alpha2) -- Top line
        DrawLine(ctx, gbb.botX + 3, gbb.topY - 1, gbb.botX + 3, gbb.botY, 0, 0, 0, alpha2) -- Left line
        
        DrawRect(ctx, gbb.botX + 3, gbb.topY - 1, 4, gbb.height + 2, 0, 0, 0, alpha) -- Background
        
        DrawLine(ctx, gbb.botX + 6, gbb.topY - 1, gbb.botX + 6, gbb.botY, 0, 0, 0, alpha2) -- Right line
        DrawLine(ctx, gbb.botX + 3, gbb.botY, gbb.botX + 6, gbb.botY, 0, 0, 0, alpha2) -- Bottom line
        
        if contains(activation_type, "Gradient") then
            DrawGradient(ctx, gbb.botX + 4, gbb.botY - health_height, 2, health_height, 0, 0, 0, alpha2, red, green, 0, alpha2, true)
        else
            DrawRect(ctx, gbb.botX + 4, gbb.botY - health_height, 2, health_height, red, green, 0, alpha2) -- Health
        end
        
        if contains(activation_type, "Battery") then
            for i = 1, 9, 1 do
                DrawLine(ctx, gbb.botX + 3, gbb.topY + i * (gbb.height / 10), gbb.topX + gbb.width + 6, gbb.topY + i * (gbb.height / 10), 0, 0, 0, alpha2) -- Top line
            end
        end
        
        if text_enabled then
            DrawText(ctx, gbb.botX + 5, gbb.botY - health_height, 255, 255, 255, alpha, "-c", 999, enemy_health)
        end
    end
    
    if contains(activation_type, "Bottom") then
        
        DrawLine(ctx, gbb.botX - gbb.width - 1, gbb.botY + 3 + overall_height_addition_bottom, gbb.botX, gbb.botY + 3 + overall_height_addition_bottom, 0, 0, 0, alpha2) -- Top line
        DrawLine(ctx, gbb.botX - gbb.width - 1, gbb.botY + 3 + overall_height_addition_bottom, gbb.botX - gbb.width - 1, gbb.botY + 6 + overall_height_addition_bottom, 0, 0, 0, alpha2) -- Left line
        
        DrawRect(ctx, gbb.botX - gbb.width - 1, gbb.botY + 3 + overall_height_addition_bottom, gbb.width + 2, 4, 0, 0, 0, alpha) -- Background
        
        DrawLine(ctx, gbb.botX - gbb.width - 1, gbb.botY + 6 + overall_height_addition_bottom, gbb.botX, gbb.botY + 6 + overall_height_addition_bottom, 0, 0, 0, alpha2) -- Bottom line
        DrawLine(ctx, gbb.botX, gbb.botY + 3 + overall_height_addition_bottom, gbb.botX, gbb.botY + 6 + overall_height_addition_bottom, 0, 0, 0, alpha2) -- Right line
        
        if contains(activation_type, "Gradient") then
            DrawGradient(ctx, gbb.botX - gbb.width, gbb.botY + 4 + overall_height_addition_bottom, health_width, 2, 0, 0, 0, alpha2, red, green, 0, alpha2, false)
        else
            DrawRect(ctx, gbb.botX - gbb.width, gbb.botY + 4 + overall_height_addition_bottom, health_width, 2, red, green, 0, alpha2) -- Health
        end
        
        if contains(activation_type, "Battery") then
            for i = 1, 9, 1 do
                DrawLine(ctx, gbb.botX - gbb.width + i * (gbb.width / 10), gbb.botY + 3 + overall_height_addition_bottom, gbb.botX - gbb.width + i * (gbb.width / 10), gbb.botY + 6 + overall_height_addition_bottom, 0, 0, 0, alpha2) -- Left line
            end
        end
        
        if text_enabled then
            DrawText(ctx, gbb.topX + health_width - 4, gbb.botY + 1 + overall_height_addition_bottom, 255, 255, 255, alpha, "-", 999, enemy_health)
        end
    end
    
    if contains(activation_type, "Left") then
        
        DrawLine(ctx, gbb.botX - gbb.width - 4, gbb.topY - 1, gbb.topX - 7, gbb.topY - 1, 0, 0, 0, alpha2) -- Top line
        DrawLine(ctx, gbb.botX - gbb.width - 4, gbb.topY - 1, gbb.botX - gbb.width - 4, gbb.botY, 0, 0, 0, alpha2) -- Left line
        
        DrawRect(ctx, gbb.botX - gbb.width - 7, gbb.topY - 1, 4, gbb.height + 2, 0, 0, 0, alpha) -- Background
        
        DrawLine(ctx, gbb.botX - gbb.width - 7, gbb.topY - 1, gbb.botX - gbb.width - 7, gbb.botY, 0, 0, 0, alpha2) -- Right line
        DrawLine(ctx, gbb.botX - gbb.width - 4, gbb.botY, gbb.botX - gbb.width - 7, gbb.botY, 0, 0, 0, alpha2) -- Bottom line
        
        if contains(activation_type, "Gradient") then
            DrawGradient(ctx, gbb.botX - gbb.width - 6, gbb.botY - health_height, 2, health_height, red, green, 0, alpha2, 0, 0, 0, alpha2, true)
        else
            DrawRect(ctx, gbb.botX - gbb.width - 6, gbb.botY - health_height, 2, health_height, red, green, 0, alpha2) -- Health
        end
        
        if contains(activation_type, "Battery") then
            for i = 1, 9, 1 do
                DrawLine(ctx, gbb.botX - gbb.width - 4, gbb.topY + i * (gbb.height / 10), gbb.topX - 7, gbb.topY + i * (gbb.height / 10), 0, 0, 0, alpha2) -- Top line
            end
        end
        
        if text_enabled then
            DrawText(ctx, gbb.botX - gbb.width - 10, gbb.botY - health_height - 4, 255, 255, 255, alpha, "-", 999, enemy_health)
        end
    end
end

local function DrawAmmo(ctx, entity_index)
    
    gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = GetBoundingBox(ctx, entity_index)
    
    if gbb.topX == nil or gbb.topY == nil or gbb.botX == nil or gbb.botY == nil or gbb.alpha == nil or gbb.alpha == 0 then return end
    
    gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    
    gbb.middle_x = (gbb.topX - gbb.botX) / 2
    gbb.middle_y = (gbb.topY - gbb.botY) / 2
    
    local weapon_id = GetProp(entity_index, "m_hActiveWeapon")
    local weapon_item_index = GetProp(weapon_id, "m_iItemDefinitionIndex")
    local ammo = GetProp(weapon_id, "m_iClip1")
    local max_ammo = get_max_ammo(entity_index)
    
    if is_misc_weapon(entity_index) then return end
    
    if weapon_id == nil or weapon_item_index == nil or ammo == nil or max_ammo == nil then return end
    
    local activation_type = GetUi(ammo_bar_mode_multi)
    local healthbar_activation_type = GetUi(healthbar_mode_multi)
    
    local is_visible = can_see(entity_index)
    
    if not GetUi(ammo_bar_invis_cb) and not is_visible then
        return
    end
    
    local red, green, blue, alpha3 = GetUi(ammo_bar_color)
    
    if not is_visible and GetUi(ammo_bar_invis_cb) then
        red, green, blue, alpha3 = GetUi(ammo_bar_invis_color)
    else
        red, green, blue, alpha3 = GetUi(ammo_bar_color)
    end
    
    local alpha = 150 * gbb.alpha
    local alpha2 = 255 * gbb.alpha
    local alpha3 = alpha3 * gbb.alpha
    
    local ammo_width = (gbb.width * ammo) / max_ammo
    local ammo_height = (gbb.height * ammo) / max_ammo
    
    local healthbar_visible_check_table = {
        ["01"] = true,
        ["00"] = false,
        ["10"] = true,
        ["11"] = true
    }
    local healthbar_visible_check = false
    healthbar_visible_check = healthbar_visible_check_table[(is_visible and 1 or 0) .. (GetUi(healthbar_invis_cb) and 1 or 0)]
    
    local text_enabled = contains(activation_type, "Text") and ammo < max_ammo
    
    if contains(activation_type, "Top") then
        
        local height_addition = 0
        
        if contains(healthbar_activation_type, "Top") and healthbar_visible_check then
            height_addition = height_addition + 6
        else
            height_addition = 0
        end
        
        DrawLine(ctx, gbb.topX - 1, gbb.topY - 7 - height_addition, gbb.topX + gbb.width, gbb.topY - 7 - height_addition, 0, 0, 0, alpha2) -- Top line
        DrawLine(ctx, gbb.topX - 1, gbb.topY - 4 - height_addition, gbb.topX - 1, gbb.topY - 7 - height_addition, 0, 0, 0, alpha2) -- Left line
        
        DrawRect(ctx, gbb.topX - 1, gbb.topY - 7 - height_addition, gbb.width + 1, 4, 0, 0, 0, alpha) -- Background
        
        DrawLine(ctx, gbb.topX - 1, gbb.topY - 4 - height_addition, gbb.topX + gbb.width, gbb.topY - 4 - height_addition, 0, 0, 0, alpha2) -- Bottom line
        DrawLine(ctx, gbb.topX + gbb.width, gbb.topY - 4 - height_addition, gbb.topX + gbb.width, gbb.topY - 7 - height_addition, 0, 0, 0, alpha2) -- Right line
        
        if contains(activation_type, "Gradient") then
            DrawGradient(ctx, gbb.topX, gbb.topY - 6 - height_addition, ammo_width, 2, red, green, blue, alpha3, 0, 0, 0, alpha3, false)
        else
            DrawRect(ctx, gbb.topX, gbb.topY - 6 - height_addition, ammo_width, 2, red, green, blue, alpha3) -- Ammo
        end

        if contains(activation_type, "Battery") then
            for i = 1, 9, 1 do
                DrawLine(ctx, gbb.topX + i * (gbb.width / 10), gbb.topY - 4 - height_addition, gbb.topX + i * (gbb.width / 10), gbb.topY - 7 - height_addition, 0, 0, 0, alpha2) -- Left line
            end
        end
        
        if text_enabled then
            DrawText(ctx, gbb.topX + ammo_width - 4, gbb.topY - 10 - height_addition, 255, 255, 255, alpha, "-", 999, ammo)
        end
    end
    
    if contains(activation_type, "Right") then
        
        local width_addition = 0
        
        if contains(healthbar_activation_type, "Right") and healthbar_visible_check then
            width_addition = width_addition + 6
        else
            width_addition = 0
        end
        
        DrawLine(ctx, gbb.botX + 3 + width_addition, gbb.topY - 1, gbb.topX + gbb.width + 6 + width_addition, gbb.topY - 1, 0, 0, 0, alpha2) -- Top line
        DrawLine(ctx, gbb.botX + 3 + width_addition, gbb.topY - 1, gbb.botX + 3 + width_addition, gbb.botY, 0, 0, 0, alpha2) -- Left line
        
        DrawRect(ctx, gbb.botX + 3 + width_addition, gbb.topY - 1, 4, gbb.height + 2, 0, 0, 0, alpha) -- Background
        
        DrawLine(ctx, gbb.botX + 6 + width_addition, gbb.topY - 1, gbb.botX + 6 + width_addition, gbb.botY, 0, 0, 0, alpha2) -- Right line
        DrawLine(ctx, gbb.botX + 3 + width_addition, gbb.botY, gbb.botX + 6 + width_addition, gbb.botY, 0, 0, 0, alpha2) -- Bottom line
        
        if contains(activation_type, "Gradient") then
            DrawGradient(ctx, gbb.botX + 4 + width_addition, gbb.botY - ammo_height, 2, ammo_height, 0, 0, 0, alpha3, red, green, blue, alpha3, true)
        else
            DrawRect(ctx, gbb.botX + 4 + width_addition, gbb.botY - ammo_height, 2, ammo_height, red, green, blue, alpha3) -- Ammo
        end

        if contains(activation_type, "Battery") then
            for i = 1, 9, 1 do
                DrawLine(ctx, gbb.botX + 3 + width_addition, gbb.topY + i * (gbb.height / 10), gbb.topX + gbb.width + 6 + width_addition, gbb.topY + i * (gbb.height / 10), 0, 0, 0, alpha2) -- Top line
            end
        end
        
        if text_enabled then
            DrawText(ctx, gbb.botX + 5 + width_addition, gbb.botY - ammo_height, 255, 255, 255, alpha, "-c", 999, ammo)
        end
    end
    
    if contains(activation_type, "Bottom") then
        
        local height_addition = 0
        
        if contains(healthbar_activation_type, "Bottom") and healthbar_visible_check then
            height_addition = height_addition + 6
        else
            height_addition = 0
        end
        
        DrawLine(ctx, gbb.botX - gbb.width - 1, gbb.botY + 3 + overall_height_addition_bottom + height_addition, gbb.botX, gbb.botY + 3 + overall_height_addition_bottom + height_addition, 0, 0, 0, alpha2) -- Top line
        DrawLine(ctx, gbb.botX - gbb.width - 1, gbb.botY + 3 + overall_height_addition_bottom + height_addition, gbb.botX - gbb.width - 1, gbb.botY + 6 + overall_height_addition_bottom + height_addition, 0, 0, 0, alpha2) -- Left line
        
        DrawRect(ctx, gbb.botX - gbb.width - 1, gbb.botY + 3 + overall_height_addition_bottom + height_addition, gbb.width + 2, 4, 0, 0, 0, alpha) -- Background
        
        DrawLine(ctx, gbb.botX - gbb.width - 1, gbb.botY + 6 + overall_height_addition_bottom + height_addition, gbb.botX, gbb.botY + 6 + overall_height_addition_bottom + height_addition, 0, 0, 0, alpha2) -- Bottom line
        DrawLine(ctx, gbb.botX, gbb.botY + 3 + overall_height_addition_bottom + height_addition, gbb.botX, gbb.botY + 6 + overall_height_addition_bottom + height_addition, 0, 0, 0, alpha2) -- Right line
        
        if contains(activation_type, "Gradient") then
            DrawGradient(ctx, gbb.botX - gbb.width, gbb.botY + 4 + overall_height_addition_bottom + height_addition, ammo_width, 2, 0, 0, 0, alpha3, red, green, blue, alpha3, false)
        else
            DrawRect(ctx, gbb.botX - gbb.width, gbb.botY + 4 + overall_height_addition_bottom + height_addition, ammo_width, 2, red, green, blue, alpha3) -- Ammo
        end

        if contains(activation_type, "Battery") then
            for i = 1, 9, 1 do
                DrawLine(ctx, gbb.botX - gbb.width + i * (gbb.width / 10), gbb.botY + 3 + overall_height_addition_bottom + height_addition, gbb.botX - gbb.width + i * (gbb.width / 10), gbb.botY + 6 + overall_height_addition_bottom + height_addition, 0, 0, 0, alpha2) -- Left line
            end
        end
        
        if text_enabled then
            DrawText(ctx, gbb.topX + ammo_width - 4, gbb.botY + 1 + overall_height_addition_bottom + height_addition, 255, 255, 255, alpha, "-", 999, ammo)
        end
    end
    
    if contains(activation_type, "Left") then
        
        local width_subtraction = 0
        
        if contains(healthbar_activation_type, "Left") and healthbar_visible_check then
            width_subtraction = width_subtraction + 6
        else
            width_subtraction = 0
        end
        
        DrawLine(ctx, gbb.botX - gbb.width - 4 - width_subtraction, gbb.topY - 1, gbb.topX - 7 - width_subtraction, gbb.topY - 1, 0, 0, 0, alpha2) -- Top line
        DrawLine(ctx, gbb.botX - gbb.width - 4 - width_subtraction, gbb.topY - 1, gbb.botX - gbb.width - 4 - width_subtraction, gbb.botY, 0, 0, 0, alpha2) -- Left line
        
        DrawRect(ctx, gbb.botX - gbb.width - 7 - width_subtraction, gbb.topY - 1, 4, gbb.height + 2, 0, 0, 0, alpha) -- Background
        
        DrawLine(ctx, gbb.botX - gbb.width - 7 - width_subtraction, gbb.topY - 1, gbb.botX - gbb.width - 7 - width_subtraction, gbb.botY, 0, 0, 0, alpha2) -- Right line
        DrawLine(ctx, gbb.botX - gbb.width - 4 - width_subtraction, gbb.botY, gbb.botX - gbb.width - 7 - width_subtraction, gbb.botY, 0, 0, 0, alpha2) -- Bottom line
        
        if contains(activation_type, "Gradient") then
            DrawGradient(ctx, gbb.botX - gbb.width - 6 - width_subtraction, gbb.botY - ammo_height, 2, ammo_height, red, green, blue, alpha3, 0, 0, 0, alpha3, true)
        else
            DrawRect(ctx, gbb.botX - gbb.width - 6 - width_subtraction, gbb.botY - ammo_height, 2, ammo_height, red, green, blue, alpha3) -- Ammo
        end

        if contains(activation_type, "Battery") then
            for i = 1, 9, 1 do
                DrawLine(ctx, gbb.botX - gbb.width - 4 - width_subtraction, gbb.topY + i * (gbb.height / 10), gbb.topX - 7 - width_subtraction, gbb.topY + i * (gbb.height / 10), 0, 0, 0, alpha2) -- Top line
            end
        end
        
        if text_enabled then
            DrawText(ctx, gbb.botX - gbb.width - 5 - width_subtraction, gbb.botY - ammo_height, 255, 255, 255, alpha, "-c", 999, ammo)
        end
    end
end

local function DrawName(ctx, entity_index)
    
    gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = GetBoundingBox(ctx, entity_index)
    
    if gbb.topX == nil or gbb.topY == nil or gbb.botX == nil or gbb.botY == nil or gbb.alpha == nil or gbb.alpha == 0 then return end
    
    gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    
    gbb.middle_x = (gbb.topX - gbb.botX) / 2
    gbb.middle_y = (gbb.topY - gbb.botY) / 2
    
    local activation_type = GetUi(name_esp_multi)
    local healthbar_activation_type = GetUi(healthbar_mode_multi)
    local ammo_bar_activation_type = GetUi(ammo_bar_mode_multi)
    
    local is_visible = can_see(entity_index)
    
    local red, green, blue, alpha = GetUi(name_esp_color)
    
    if not is_visible and GetUi(name_esp_invis_cb) then
        red, green, blue, alpha = GetUi(name_esp_invis_color)
    else
        red, green, blue, alpha = GetUi(name_esp_color)
    end
    
    if not is_visible and GetUi(name_esp_invis_cb) == false then
        return
    end
    
    alpha = alpha * gbb.alpha
    
    local enemy_name = GetPlayerName(entity_index)
    
    local fixed_name = enemy_name
    
    if enemy_name:len() > 20 then
        fixed_name = string.sub(enemy_name, 0, 20)
    end
    
    local name_flags = "cb"
    local name_flags_right = "lb"
    local name_flags_left = "rb"
    
    if GetUi(name_font_combo) == "Bold" then
        name_flags = "cb"
        name_flags_right = "lb"
        name_flags_left = "rb"
    elseif GetUi(name_font_combo) == "Normal" then
        name_flags = "c"
        name_flags_right = "l"
        name_flags_left = "r"
    end
    
    local healthbar_visible_check_table = {
        ["01"] = true,
        ["00"] = false,
        ["10"] = true,
        ["11"] = true
    }
    local healthbar_visible_check = false
    healthbar_visible_check = healthbar_visible_check_table[(is_visible and 1 or 0) .. (GetUi(healthbar_invis_cb) and 1 or 0)]
    
    local ammo_bar_visible_check_table = {
        ["01"] = true,
        ["00"] = false,
        ["10"] = true,
        ["11"] = true
    }
    local ammo_bar_visible_check = false
    ammo_bar_visible_check = ammo_bar_visible_check_table[(is_visible and 1 or 0) .. (GetUi(ammo_bar_invis_cb) and 1 or 0)]
    
    if contains(activation_type, "Top") then
        
        local height_addition = 1
        
        local height_addition_table = {
            ["00"] = 1,
            ["10"] = 7,
            ["01"] = 7,
            ["11"] = 13,
        }
        height_addition = height_addition_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Top")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Top")) and 1 or 0)] or 0
        
        DrawText(ctx, gbb.botX - gbb.width - gbb.middle_x, gbb.topY - 6 - height_addition, red, green, blue, alpha, name_flags, 25, fixed_name)
    end
    
    if contains(activation_type, "Right(Top)") then
        
        local width_addition_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 12,
        }
        width_addition = width_addition_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Right")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Right")) and 1 or 0)] or 0
        
        if GetUi(name_font_combo) == "Bold" then width_addition = width_addition + 1 end
        
        DrawText(ctx, gbb.botX + 2 + width_addition, gbb.topY - 4 + overall_height_addition_right, red, green, blue, alpha, name_flags_right, 25, fixed_name)
    end
    
    if contains(activation_type, "Right(Bottom)") then
        
        local width_addition_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 12,
        }
        width_addition = width_addition_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Right")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Right")) and 1 or 0)] or 0
        
        if GetUi(name_font_combo) == "Bold" then width_addition = width_addition + 1 end
        
        DrawText(ctx, gbb.botX + 2 + width_addition, gbb.botY - 10, red, green, blue, alpha, name_flags_right, 25, fixed_name)
    end
    
    if contains(activation_type, "Bottom") then
        local height_subtraction = 1
        
        local height_subtraction_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 12,
        }
        height_subtraction = height_subtraction_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Bottom")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Bottom")) and 1 or 0)] or 0
        
        DrawText(ctx, gbb.botX - gbb.width - gbb.middle_x, gbb.botY + 6 + height_subtraction + overall_height_addition_bottom, red, green, blue, alpha, name_flags, 25, fixed_name)
    end
    
    if contains(activation_type, "Left(Top)") then
        
        local width_subtraction_table = {
            ["00"] = 2,
            ["10"] = 8,
            ["01"] = 8,
            ["11"] = 14,
        }
        width_subtraction = width_subtraction_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Left")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Left")) and 1 or 0)] or 0
        
        DrawText(ctx, gbb.topX - width_subtraction, gbb.topY - 4, red, green, blue, alpha, name_flags_left, 12, fixed_name)
    end
    
    if contains(activation_type, "Left(Bottom)") then
        
        local width_subtraction_table = {
            ["00"] = 0,
            ["10"] = 8,
            ["01"] = 8,
            ["11"] = 14,
        }
        width_subtraction = width_subtraction_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Left")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Left")) and 1 or 0)] or 0
        
        DrawText(ctx, gbb.topX - 1 - width_subtraction, gbb.botY - 10, red, green, blue, alpha, name_flags_left, 12, fixed_name)
    end
end

local function DrawWeapon(ctx, entity_index)
    
    gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = GetBoundingBox(ctx, entity_index)
    
    if gbb.topX == nil or gbb.topY == nil or gbb.botX == nil or gbb.botY == nil or gbb.alpha == nil or gbb.alpha == 0 then return end
    
    gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    
    gbb.middle_x = (gbb.topX - gbb.botX) / 2
    gbb.middle_y = (gbb.topY - gbb.botY) / 2
    
    local activation_type = GetUi(weapon_esp_multi)
    local name_activation_type = GetUi(name_esp_multi)
    local healthbar_activation_type = GetUi(healthbar_mode_multi)
    local ammo_bar_activation_type = GetUi(ammo_bar_mode_multi)
    
    local is_visible = can_see(entity_index)
    
    local red, green, blue, alpha = GetUi(weapon_esp_color)
    
    if not is_visible and GetUi(weapon_esp_invis_cb) then
        red, green, blue, alpha = GetUi(weapon_esp_invis_color)
    else
        red, green, blue, alpha = GetUi(weapon_esp_color)
    end
    
    if not is_visible and GetUi(weapon_esp_invis_cb) == false then
        return
    end
    
    alpha = alpha * gbb.alpha
    local enemy_weapon = get_weapon_name(entity.get_player_weapon(entity_index))
    
    local weapon_flags = "cb"
    local weapon_flags_left = "rb"
    local weapon_flags_right = "lb"
    
    if GetUi(weapon_font_combo) == "Bold" then
        weapon_flags = "cb"
        weapon_flags_left = "rb"
        weapon_flags_right = "lb"
    elseif GetUi(weapon_font_combo) == "Normal" then
        weapon_flags = "c"
        weapon_flags_left = "r"
        weapon_flags_right = "l"
    elseif GetUi(weapon_font_combo) == "Small" then
        weapon_flags = "-  c"
        weapon_flags_left = "-r"
        weapon_flags_right = "-l"
    end
    
    local healthbar_visible_check_table = {
        ["01"] = true,
        ["00"] = false,
        ["10"] = true,
        ["11"] = true
    }
    local healthbar_visible_check = false
    healthbar_visible_check = healthbar_visible_check_table[(is_visible and 1 or 0) .. (GetUi(healthbar_invis_cb) and 1 or 0)]
    
    local name_visible_check_table = {
        ["01"] = true,
        ["00"] = false,
        ["10"] = true,
        ["11"] = true
    }
    local name_visible_check = false
    name_visible_check = name_visible_check_table[(is_visible and 1 or 0) .. (GetUi(name_esp_invis_cb) and 1 or 0)]
    
    local ammo_bar_visible_check_table = {
        ["01"] = true,
        ["00"] = false,
        ["10"] = true,
        ["11"] = true
    }
    local ammo_bar_visible_check = false
    ammo_bar_visible_check = ammo_bar_visible_check_table[(is_visible and 1 or 0) .. (GetUi(ammo_bar_invis_cb) and 1 or 0)]
    
    if contains(activation_type, "Top") then
        
        local height_addition = 0
        
        local height_addition_table = {
            ["000"] = 0,
            ["001"] = 7,
            ["010"] = 10,
            ["100"] = 7,
            ["011"] = 16,
            ["101"] = 14,
            ["110"] = 16,
            ["111"] = 22,
        }
        height_addition = height_addition_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Top")) and 1 or 0)
            .. ((name_visible_check and contains(name_activation_type, "Top")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Top")) and 1 or 0)] or 0
        
        if GetUi(weapon_font_combo) == "Small" then height_addition = height_addition - 2 end
        
        DrawText(ctx, gbb.botX - gbb.width - gbb.middle_x, gbb.topY - 6 - height_addition, red, green, blue, alpha, weapon_flags, 999, enemy_weapon)
    end
    
    if contains(activation_type, "Right(Top)") then
        
        local width_addition = 0
        
        local width_addition_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 12,
        }
        width_addition = width_addition_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Right")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Right")) and 1 or 0)] or 0
        
        local height_addition = 0
        
        if contains(name_activation_type, "Right(Top)") and name_visible_check then
            height_addition = height_addition + 3
        else
            height_addition = -6
        end
        
        if GetUi(weapon_font_combo) == "Bold" or GetUi(weapon_font_combo) == "Small" then width_addition = width_addition + 1 end
        if GetUi(weapon_font_combo) == "Small" then height_addition = height_addition + 2 end
        
        DrawText(ctx, gbb.botX + 2 + width_addition, gbb.topY + 2 + height_addition + overall_height_addition_right, red, green, blue, alpha, weapon_flags_right, 999, enemy_weapon)
    end
    
    if contains(activation_type, "Right(Bottom)") then
        
        local width_addition = 0
        
        local width_addition_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 12,
        }
        width_addition = width_addition_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Right")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Right")) and 1 or 0)] or 0
        
        local height_addition = 0
        
        if contains(name_activation_type, "Right(Bottom)") and name_visible_check then
            height_addition = height_addition + 9
        else
            height_addition = 0
        end
        
        if GetUi(weapon_font_combo) == "Bold" or GetUi(weapon_font_combo) == "Small" then width_addition = width_addition + 1 end
        if GetUi(weapon_font_combo) == "Small" then height_addition = height_addition - 2 end
        
        DrawText(ctx, gbb.botX + 2 + width_addition, gbb.botY - 10 - height_addition, red, green, blue, alpha, weapon_flags_right, 999, enemy_weapon)
    end
    
    if contains(activation_type, "Bottom") then
        local height_subtraction = 0
        
        local height_subtraction_table = {
            ["000"] = 0,
            ["001"] = 6,
            ["010"] = 9,
            ["100"] = 6,
            ["011"] = 15,
            ["101"] = 12,
            ["110"] = 16,
            ["111"] = 21,
        }
        height_subtraction = height_subtraction_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Bottom")) and 1 or 0)
            .. ((name_visible_check and contains(name_activation_type, "Bottom")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Bottom")) and 1 or 0)] or 0
        
        if GetUi(weapon_font_combo) == "Small" then height_subtraction = height_subtraction + 1 end
        
        DrawText(ctx, gbb.botX - gbb.width - gbb.middle_x, gbb.botY + 6 + height_subtraction + overall_height_addition_bottom, red, green, blue, alpha, weapon_flags, 999, enemy_weapon)
    end
    
    if contains(activation_type, "Left(Top)") then
        
        local width_subtraction = 0
        
        local width_subtraction_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 12,
        }
        width_subtraction = width_subtraction_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Left")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Left")) and 1 or 0)] or 0
        
        local height_subtraction = 0
        
        if contains(name_activation_type, "Left(Top)") and name_visible_check then
            height_subtraction = height_subtraction + 9
        else
            height_subtraction = 0
        end
        
        if GetUi(weapon_font_combo) == "Small" then height_subtraction = height_subtraction + 2 width_subtraction = width_subtraction + 2 end
        
        DrawText(ctx, gbb.topX - 2 - width_subtraction, gbb.topY - 4 + height_subtraction, red, green, blue, alpha, weapon_flags_left, 999, enemy_weapon)
    end
    
    if contains(activation_type, "Left(Bottom)") then
        
        local width_subtraction = 0
        
        local width_subtraction_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 12,
        }
        width_subtraction = width_subtraction_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Left")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Left")) and 1 or 0)] or 0
        
        local height_subtraction = 0
        
        if contains(name_activation_type, "Left(Bottom)") and name_visible_check then
            height_subtraction = height_subtraction + 15
        else
            height_subtraction = 6
        end
        
        if GetUi(weapon_font_combo) == "Small" then height_subtraction = height_subtraction - 2 width_subtraction = width_subtraction + 2 end
        
        DrawText(ctx, gbb.topX - 2 - width_subtraction, gbb.botY - 4 - height_subtraction, red, green, blue, alpha, weapon_flags_left, 999, enemy_weapon)
    end
end

local function DrawDistance(ctx, entity_index)
    
    gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = GetBoundingBox(ctx, entity_index)
    
    if gbb.topX == nil or gbb.topY == nil or gbb.botX == nil or gbb.botY == nil or gbb.alpha == nil or gbb.alpha == 0 then return end
    
    gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    
    gbb.middle_x = (gbb.topX - gbb.botX) / 2
    gbb.middle_y = (gbb.topY - gbb.botY) / 2
    
    local activation_type = GetUi(distance_esp_multi)
    local weapon_activation_type = GetUi(weapon_esp_multi)
    local name_activation_type = GetUi(name_esp_multi)
    local healthbar_activation_type = GetUi(healthbar_mode_multi)
    local ammo_bar_activation_type = GetUi(ammo_bar_mode_multi)
    
    local is_visible = can_see(entity_index)
    
    local healthbar_visible_check_table = {
        ["01"] = true,
        ["00"] = false,
        ["10"] = true,
        ["11"] = true
    }
    local healthbar_visible_check = false
    healthbar_visible_check = healthbar_visible_check_table[(is_visible and 1 or 0) .. (GetUi(healthbar_invis_cb) and 1 or 0)]
    
    local name_visible_check_table = {
        ["01"] = true,
        ["00"] = false,
        ["10"] = true,
        ["11"] = true
    }
    local name_visible_check = false
    name_visible_check = name_visible_check_table[(is_visible and 1 or 0) .. (GetUi(name_esp_invis_cb) and 1 or 0)]
    
    local weapon_visible_check_table = {
        ["01"] = true,
        ["00"] = false,
        ["10"] = true,
        ["11"] = true
    }
    local weapon_visible_check = false
    weapon_visible_check = weapon_visible_check_table[(is_visible and 1 or 0) .. (GetUi(weapon_esp_invis_cb) and 1 or 0)]
    
    local ammo_bar_visible_check_table = {
        ["01"] = true,
        ["00"] = false,
        ["10"] = true,
        ["11"] = true
    }
    local ammo_bar_visible_check = false
    ammo_bar_visible_check = ammo_bar_visible_check_table[(is_visible and 1 or 0) .. (GetUi(ammo_bar_invis_cb) and 1 or 0)]
    
    local red, green, blue, alpha = GetUi(distance_esp_color)
    
    if not is_visible and GetUi(distance_esp_invis_cb) then
        red, green, blue, alpha = GetUi(distance_esp_invis_color)
    else
        red, green, blue, alpha = GetUi(distance_esp_color)
    end
    
    if not is_visible and GetUi(distance_esp_invis_cb) == false then
        return
    end
    alpha = alpha * gbb.alpha
    
    local distance_flags = "cb"
    local distance_flags_right = "lb"
    local distance_flags_left = "rb"
    
    if GetUi(distance_font_combo) == "Bold" then
        distance_flags = "cb"
        distance_flags_right = "lb"
        distance_flags_left = "rb"
    elseif GetUi(distance_font_combo) == "Normal" then
        distance_flags = "c"
        distance_flags_right = "l"
        distance_flags_left = "r"
    elseif GetUi(distance_font_combo) == "Small" then
        distance_flags = "-c"
        distance_flags_right = "-l"
        distance_flags_left = "-r"
    end
    
    local local_player_origin = {x, y, z}
    local_player_origin.x, local_player_origin.y, local_player_origin.z = GetProp(GetLocalPlayer(), "m_vecOrigin")
    
    local enemy_origin = {x, y, z}
    enemy_origin.x, enemy_origin.y, enemy_origin.z = GetProp(entity_index, "m_vecOrigin")
    
    local distance_value = GetDistanceInFeet(local_player_origin.x, local_player_origin.y, local_player_origin.z, enemy_origin.x, enemy_origin.y, enemy_origin.z)
    
    if GetUi(distance_mode_combo) == "Meter" then
        distance_value = GetDistanceInMeter(local_player_origin.x, local_player_origin.y, local_player_origin.z, enemy_origin.x, enemy_origin.y, enemy_origin.z)
    elseif GetUi(distance_mode_combo) == "Feet" then
        distance_value = GetDistanceInFeet(local_player_origin.x, local_player_origin.y, local_player_origin.z, enemy_origin.x, enemy_origin.y, enemy_origin.z)
    elseif GetUi(distance_mode_combo) == "Units" then
        distance_value = GetDistanceInUnits(local_player_origin.x, local_player_origin.y, local_player_origin.z, enemy_origin.x, enemy_origin.y, enemy_origin.z)
    end
    
    if contains(activation_type, "Top") then
        
        local height_addition = 0
        
        local height_addition_table = {
            ["0000"] = 1,
            ["0001"] = 7,
            ["1000"] = 7,
            ["0010"] = 9,
            ["0100"] = 10,
            ["0011"] = 10,
            ["0101"] = 16,
            ["1001"] = 13,
            ["1100"] = 16,
            ["1010"] = 19,
            ["0110"] = 19,
            ["1011"] = 25,
            ["0111"] = 25,
            ["1110"] = 25,
            ["1101"] = 22,
            ["1111"] = 31,
        }
        height_addition = height_addition_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Top")) and 1 or 0)
            .. ((name_visible_check and contains(name_activation_type, "Top")) and 1 or 0)
            .. ((weapon_visible_check and contains(weapon_activation_type, "Top")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Top")) and 1 or 0)] or 0
        
        if GetUi(distance_font_combo) == "Small" then height_addition = height_addition - 1 end
        
        DrawText(ctx, gbb.botX - gbb.width - gbb.middle_x, gbb.topY - 6 - height_addition, red, green, blue, alpha, distance_flags, 999, distance_value)
    end
    
    if contains(activation_type, "Right(Top)") then
        
        local width_addition = 0
        
        local width_addition_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 12,
        }
        width_addition = width_addition_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Right")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Right")) and 1 or 0)] or 0
        
        local height_addition = 0
        
        local height_addition_table = {
            ["01"] = 3,
            ["00"] = -6,
            ["10"] = 3,
            ["11"] = 12
        }
        height_addition = height_addition_table[((contains(weapon_activation_type, "Right(Top)") and weapon_visible_check) and 1 or 0)
        .. ((contains(name_activation_type, "Right(Top)") and name_visible_check) and 1 or 0)]
        
        if GetUi(distance_font_combo) == "Small" or GetUi(distance_font_combo) == "Bold" then width_addition = width_addition + 1 end
        if GetUi(distance_font_combo) == "Small" then height_addition = height_addition + 2 end
        
        DrawText(ctx, gbb.botX + 2 + width_addition, gbb.topY + 2 + height_addition + overall_height_addition_right, red, green, blue, alpha, distance_flags_right, 999, distance_value)
    end
    
    if contains(activation_type, "Right(Bottom)") then
        
        local width_addition = 0
        
        local width_addition_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 12,
        }
        width_addition = width_addition_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Right")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Right")) and 1 or 0)] or 0
        
        local height_addition = 1
        
        local height_addition_table = {
            ["01"] = 17,
            ["00"] = 8,
            ["10"] = 17,
            ["11"] = 26
        }
        height_addition = height_addition_table[((contains(weapon_activation_type, "Right(Bottom)") and weapon_visible_check) and 1 or 0)
        .. ((contains(name_activation_type, "Right(Bottom)") and name_visible_check) and 1 or 0)]
        
        if GetUi(distance_font_combo) == "Small" or GetUi(distance_font_combo) == "Bold" then width_addition = width_addition + 1 end
        if GetUi(distance_font_combo) == "Small" then height_addition = height_addition - 2 end
        
        DrawText(ctx, gbb.botX + 2 + width_addition, gbb.botY - 2 - height_addition, red, green, blue, alpha, distance_flags_right, 999, distance_value)
    end
    
    if contains(activation_type, "Bottom") then
        
        local height_subtraction = 0
        
        local height_subtraction_table = {
            ["0000"] = 0,
            ["0001"] = 7,
            ["1000"] = 7,
            ["0010"] = 9,
            ["0100"] = 10,
            ["0011"] = 15,
            ["0101"] = 16,
            ["1001"] = 13,
            ["1100"] = 16,
            ["1010"] = 19,
            ["0110"] = 19,
            ["1011"] = 25,
            ["0111"] = 25,
            ["1110"] = 25,
            ["1101"] = 22,
            ["1111"] = 31,
        }
        height_subtraction = height_subtraction_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Bottom")) and 1 or 0)
            .. ((name_visible_check and contains(name_activation_type, "Bottom")) and 1 or 0)
            .. ((weapon_visible_check and contains(weapon_activation_type, "Bottom")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Bottom")) and 1 or 0)] or 0
        
        if GetUi(distance_font_combo) == "Small" then height_subtraction = height_subtraction + 1 end
        
        DrawText(ctx, gbb.botX - gbb.width - gbb.middle_x, gbb.botY + 6 + height_subtraction + overall_height_addition_bottom, red, green, blue, alpha, distance_flags, 999, distance_value)
    end
    
    if contains(activation_type, "Left(Top)") then
        
        local width_subtraction_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 13,
        }
        width_subtraction = width_subtraction_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Left")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Left")) and 1 or 0)] or 0
        
        local height_subtraction = 0
        
        local height_subtraction_table = {
            ["01"] = 5,
            ["00"] = -4,
            ["10"] = 5,
            ["11"] = 14
        }
        height_subtraction = height_subtraction_table[((contains(weapon_activation_type, "Left(Top)") and weapon_visible_check) and 1 or 0)
        .. ((contains(name_activation_type, "Left(Top)") and name_visible_check) and 1 or 0)]
        
        if GetUi(distance_font_combo) == "Small" then height_subtraction = height_subtraction + 2 width_subtraction = width_subtraction + 2 end
        
        DrawText(ctx, gbb.topX - 2 - width_subtraction, gbb.topY + height_subtraction, red, green, blue, alpha, distance_flags_left, 999, distance_value)
    end
    
    if contains(activation_type, "Left(Bottom)") then
        
        local width_subtraction_table = {
            ["00"] = 0,
            ["10"] = 6,
            ["01"] = 6,
            ["11"] = 13,
        }
        
        width_subtraction = width_subtraction_table[
            ((healthbar_visible_check and contains(healthbar_activation_type, "Left")) and 1 or 0)
        .. ((ammo_bar_visible_check and contains(ammo_bar_activation_type, "Left")) and 1 or 0)] or 0
        
        local height_subtraction = 0
        
        local height_subtraction_table = {
            ["01"] = 17,
            ["00"] = 8,
            ["10"] = 17,
            ["11"] = 26
        }
        height_subtraction = height_subtraction_table[((contains(weapon_activation_type, "Left(Bottom)") and weapon_visible_check) and 1 or 0)
        .. ((contains(name_activation_type, "Left(Bottom)") and name_visible_check) and 1 or 0)]
        
        if GetUi(distance_font_combo) == "Small" then height_subtraction = height_subtraction - 2 width_subtraction = width_subtraction + 2 end
        
        DrawText(ctx, gbb.topX - 2 - width_subtraction, gbb.botY - 2 - height_subtraction, red, green, blue, alpha, distance_flags_left, 999, distance_value)
    end
end

AddEvent("paint", function(ctx)
    local players = get_dormant_players(not GetUi(teammates_checkbox), true)
    
    for i = 1, #players do
        local player = players[i]
        
        local spectator_target = GetProp(GetLocalPlayer(), "m_iObserverMode") == 5 and GetProp(GetLocalPlayer(), "m_hObserverTarget") or nil
        
        if player ~= spectator_target then
            local enabled = GetUi(esp_builder_checkbox)
            
            if enabled and activation_type_ref then
                
                if GetUi(box_mode_combo) == "2D" then
                    DrawBoxEsp(ctx, player)
                elseif GetUi(box_mode_combo) == "3D" then
                    Draw3DEsp(ctx, player)
                elseif GetUi(box_mode_combo) == "Pentagon" then
                    DrawPentagonEsp(ctx, player)
                elseif GetUi(box_mode_combo) == "Hexagon" then
                    DrawHexagonEsp(ctx, player)
                end
                
                DrawHealthbar(ctx, player)
                DrawAmmo(ctx, player)
                DrawName(ctx, player)
                DrawWeapon(ctx, player)
                DrawDistance(ctx, player)
            end
        end
    end
end)

-- Ugly code incomming --

local function set_invisible()
    SetVisible(box_mode_combo, false)
    SetVisible(teammates_checkbox, false)
    SetVisible(teammates_color, false)
    SetVisible(box_color, false)
    SetVisible(box_invis_cb, false)
    SetVisible(box_invis_color, false)
    
    SetVisible(corner_width, false)
    SetVisible(corner_height, false)
    
    SetVisible(fill_cb, false)
    SetVisible(fill_color, false)
    SetVisible(fill_invis_cb, false)
    SetVisible(fill_invis_color, false)
    
    SetVisible(healthbar_mode_multi, false)
    SetVisible(ammo_bar_mode_multi, false)
    SetVisible(ammo_bar_color, false)
    SetVisible(ammo_bar_invis_cb, false)
    SetVisible(ammo_bar_invis_color, false)
    
    SetVisible(name_esp_multi, false)
    SetVisible(name_esp_color, false)
    SetVisible(name_font_combo, false)
    SetVisible(name_esp_invis_cb, false)
    SetVisible(name_esp_invis_color, false)
    
    SetVisible(weapon_esp_multi, false)
    SetVisible(weapon_esp_color, false)
    SetVisible(weapon_font_combo, false)
    SetVisible(weapon_esp_invis_cb, false)
    SetVisible(weapon_esp_invis_color, false)
    
    SetVisible(distance_esp_multi, false)
    SetVisible(distance_esp_color, false)
    SetVisible(distance_mode_combo, false)
    SetVisible(distance_font_combo, false)
    SetVisible(distance_esp_invis_cb, false)
    SetVisible(distance_esp_invis_color, false)
end
set_invisible()

AddEvent("paint", function()
    local enabled = GetUi(esp_builder_checkbox)
    local box_mode = GetUi(box_mode_combo) ~= "None" and enabled
    local box_mode2d = GetUi(box_mode_combo) == "2D" and enabled
    local box_mode3d = GetUi(box_mode_combo) == "3D" and enabled
    
    local name_esp_enabled = not table.empty(GetUi(name_esp_multi)) and enabled
    local weapon_esp_enabled = not table.empty(GetUi(weapon_esp_multi)) and enabled
    local distance_esp_enabled = not table.empty(GetUi(distance_esp_multi)) and enabled
    local ammo_bar_enabled = not table.empty(GetUi(ammo_bar_mode_multi)) and enabled
    local health_bar_enabled = not table.empty(GetUi(healthbar_mode_multi)) and enabled
    
    SetVisible(box_mode_combo, enabled)
    SetVisible(teammates_checkbox, enabled)
    SetVisible(teammates_color, enabled)
    SetVisible(box_color, box_mode)
    SetVisible(box_invis_cb, box_mode)
    SetVisible(box_invis_color, box_mode)
    
    SetVisible(corner_width, box_mode2d)
    SetVisible(corner_height, box_mode2d)
    
    SetVisible(fill_cb, box_mode2d)
    SetVisible(fill_color, box_mode2d)
    SetVisible(fill_invis_cb, GetUi(fill_cb) and box_mode2d)
    SetVisible(fill_invis_color, GetUi(fill_cb) and box_mode2d)
    
    SetVisible(healthbar_mode_multi, enabled)
    SetVisible(healthbar_invis_cb, health_bar_enabled)
    
    SetVisible(ammo_bar_mode_multi, enabled)
    SetVisible(ammo_bar_color, ammo_bar_enabled)
    SetVisible(ammo_bar_invis_cb, ammo_bar_enabled)
    SetVisible(ammo_bar_invis_color, ammo_bar_enabled)
    
    SetVisible(name_esp_multi, enabled)
    SetVisible(name_esp_color, name_esp_enabled)
    SetVisible(name_font_combo, name_esp_enabled)
    SetVisible(name_esp_invis_cb, name_esp_enabled)
    SetVisible(name_esp_invis_color, name_esp_enabled)
    
    SetVisible(weapon_esp_multi, enabled)
    SetVisible(weapon_esp_color, weapon_esp_enabled)
    SetVisible(weapon_font_combo, weapon_esp_enabled)
    SetVisible(weapon_esp_invis_cb, weapon_esp_enabled)
    SetVisible(weapon_esp_invis_color, weapon_esp_enabled)
    
    SetVisible(distance_esp_multi, enabled)
    SetVisible(distance_esp_color, distance_esp_enabled)
    SetVisible(distance_mode_combo, distance_esp_enabled)
    SetVisible(distance_font_combo, distance_esp_enabled)
    SetVisible(distance_esp_invis_cb, distance_esp_enabled)
    SetVisible(distance_esp_invis_color, distance_esp_enabled)
end)

local execute_once = true

AddEvent("paint", function()
    
    local enabled = GetUi(esp_builder_checkbox)
    local box_mode = GetUi(box_mode_combo) ~= "Off" and enabled
    local healthbar_enabled = not table.empty(GetUi(healthbar_mode_multi)) and enabled
    local ammo_bar_enabled = not table.empty(GetUi(ammo_bar_mode_multi)) and enabled
    local name_esp_enabled = not table.empty(GetUi(name_esp_multi)) and enabled
    local weapon_esp_enabled = not table.empty(GetUi(weapon_esp_multi)) and enabled
    local distance_esp_enabled = not table.empty(GetUi(distance_esp_multi)) and enabled
    
    SetVisible(bounding_box, not box_mode)
    SetVisible(bounding_box_color, not box_mode)
    SetVisible(health_bar, not enabled)
    SetVisible(name, not enabled)
    SetVisible(name_color, not enabled)
    SetVisible(weapon_text, not enabled)
    SetVisible(distance, not enabled)
    SetVisible(teammate_ref, not enabled)
    
    if enabled then
        SetUi(bounding_box, false)
        SetUi(health_bar, false)
        SetUi(name, false)
        SetUi(weapon_text, false)
        SetUi(distance, false)
    end
    
    if enabled then
        SetUi(teammate_ref, GetUi(teammates_checkbox) and enabled) -- needs to be used otherwise get_bounding_box doesnt update for teammates
        if execute_once then
            SetUi(out_of_fov_ref_cb, true) -- has to be set to true otherwise get_bounding_box doesnt update and or returns 0
            execute_once = false
        end
    end
end)
