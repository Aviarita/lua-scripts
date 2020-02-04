package.path = package.path .. ".\\?.lua;.\\?.ljbc;.\\lib\\?.lua;.\\libs\\?.lua;.\\lib\\?.ljbc;.\\libs\\?.ljbc;"
local bit = require("bit")
local ffi = require("ffi")
local surface, err = pcall(require, "surface")
if err and surface == false then
    client.log(err)
    error("Please download the surface library and name it surface.ljbc/.lua to use this script")
    return
end

ffi.cdef[[
    struct CCSWeaponInfo {
        char _0x0000[20];
        int iMaxClip1;
        char _0x0070[0x70];
        char* szHudName;
        char* szWeaponName;
    };

    typedef bool(__thiscall* is_weapon_t)(void*);
    typedef struct CCSWeaponInfo*(__thiscall* get_ccs_weapon_info_t)(void*);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef int(__thiscall* get_highest_entity_by_index_t)(void*);
]]

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(ffi.typeof("void***"), rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)
local get_highest_entity_by_index = ffi.cast("get_highest_entity_by_index_t", ientitylist[0][6]) or error("get_highest_entity_by_index is nil", 2)

local old_name = ui.new_checkbox("visuals", "player esp", "Old name")
local old_name_clr = ui.new_color_picker("visuals", "player esp", "Old name color", 255, 255, 255, 255)
local old_name_font = ui.new_combobox("visuals", "player esp", "\nfont", {"Normal", "Bold"})
local old_weapon_icons = ui.new_checkbox("visuals", "player esp", "Old Weapon Icons")
local old_weapon_icons_clr = ui.new_color_picker("visuals", "player esp", "Old Weapon Icons color", 255, 255, 255, 255)

local dropped_weapon_esp_checkbox = ui.new_checkbox("visuals", "other esp", "Old dropped weapons")
local dropped_weapon_esp_color = ui.new_color_picker("visuals", "other esp", "Old dropped weapons", 255, 255, 255, 255)
local dropped_weapon_ammo_esp_checkbox = ui.new_checkbox("visuals", "other esp", "Old dropped weapons ammo")
local dropped_weapon_ammo_esp_color = ui.new_color_picker("visuals", "other esp", "Old dropped weapons ammo", 56, 159, 252, 200)

local teammates_ref = ui.reference("visuals", "player esp", "teammates")

local ammo_ref = ui.reference("visuals", "player esp", "ammo")
local distance_ref = ui.reference("visuals", "player esp", "distance")
local weapon_text_ref = ui.reference("visuals", "player esp", "weapon text")
local weapon_icon_ref = ui.reference("visuals", "player esp", "weapon icon")
local dpi_scale_ref = ui.reference("misc", "settings", "dpi scale")

local weapon_icon_char = {
    [1] = "F", -- Deagle
    [2] = "S", -- Duals
    [3] = "U", -- five seven
    [4] = "C", -- glock
    [7] = "B", -- ak
    [8] = "E", -- aug
    [9] = "R",  -- awp
    [10] = "T", -- famas
    [11] = "I", -- t auto
    [13] = "V", -- galil
    [14] = "Z", -- ms249
    [16] = "W", -- m4a4
    [17] = "L", -- mac 10
    [19] = "M", -- p90
    [23] = "X", -- mp5-sd
    [24] = "Q", -- ump
    [25] = "]", -- xm1014
    [26] = "D", -- bizon
    [27] = "K", -- mag7
    [28] = "Z", -- negev
    [29] = "K", -- sawed off
    [30] = "C", -- tec9
    [31] = "Y", -- Taser
    [32] = "A", -- p2k
    [33] = "X", -- mp7
    [34] = "D", -- mp9
    [35] = "K", -- nova
    [36] = "Y", -- p250
    [38] = "O", -- ct auto
    [39] = "[", -- sg553/sg556
    [40] = "N", -- scout
    [41] = "J", -- Knife
    [42] = "J", -- Knife
    [43] = "G", -- Flashbang
    [44] = "H", -- Grenade
    [45] = "P", -- Smoke
    [47] = "G", -- Decoy
    [49] = "j", -- C4
    [55] = "f", -- Defuser
    [59] = "J", -- Knife
    [60] = "W", -- m4a1s
    [61] = "A", -- usps
    [500] = "J", -- knife
    [505] = "J", -- knife
    [506] = "J", -- knife
    [507] = "J", -- knife
    [508] = "J", -- knife
    [509] = "J", -- knife
    [512] = "J", -- knife
    [514] = "J", -- knife
    [515] = "J", -- knife
    [516] = "J", -- knife
    [519] = "J", -- knife
    [520] = "J", -- knife
    [522] = "J", -- knife
    [523] = "J", -- knife
}
 
local function get_weapon_index(ent)
    local m_iItemDefinitionIndex = entity.get_prop(ent, "m_iItemDefinitionIndex")
    if m_iItemDefinitionIndex ~= nil then
        local weapon_item_index = bit.band(m_iItemDefinitionIndex, 0xFFFF)
        return weapon_item_index
    end
end

local function get_icon_for_weapon_index(ent)
    return weapon_icon_char[get_weapon_index(ent)]
end

local function round(b, c) local d = 10 ^ (c or 0) return math.floor(b * d + 0.5) / d end
local function round_to_fifth(num) num = round(num, 0) num = num / 5 num = round(num, 0) num = num * 5 return num end

local function get_distance_in_feet(a_x, a_y, a_z, b_x, b_y, b_z)
    return math.ceil(math.sqrt(math.pow(a_x - b_x, 2) + math.pow(a_y - b_y, 2) + math.pow(a_z - b_z, 2)) * 0.0254 / 0.3048)
end

local weapon_icons_font = renderer.create_font("Counter-Strike", 22, 400, {0x010,0x080})
local bomb_icon_font = renderer.create_font("Counter-Strike", 18, 400, {0x010,0x080})
local weapon_text_font = renderer.create_font("Small Fonts", 8, 350, {0x010,0x200})
local normal_font = renderer.create_font("Verdana", 12, 0, {0x080, 0x010})
local bold_font = renderer.create_font("Verdana", 12, 700, {0x080})

local function reinit_fonts(dpi, dpin)
    weapon_icons_font = renderer.create_font("Counter-Strike", 22 * dpi, 400, {0x010,0x080})
    bomb_icon_font = renderer.create_font("Counter-Strike", 18 * dpi, 400, {0x010,0x080})
    weapon_text_font = renderer.create_font("Small Fonts", 8 * dpi, 350, {0x010,0x200})
    normal_font = renderer.create_font("Verdana", 12 * dpin, 0, {0x080, 0x010})
    bold_font = renderer.create_font("Verdana", 12 * dpin, 700, {0x080})
end

ui.set_callback(dpi_scale_ref, function(self)
    local value = ui.get(self)
    if value == "100%" then
        reinit_fonts(1, 1.05)
    elseif value == "125%" then
        reinit_fonts(1.5, 1.1)
    elseif value == "150%" then
        reinit_fonts(2, 1.2)
    elseif value == "175%" then
        reinit_fonts(2.5, 1.3)
    elseif value == "200%" then
        reinit_fonts(3, 1.4)
    end
end)

local function draw_weapon_icons(ent)

    local x0, y0, x1, y1, alpha = entity.get_bounding_box(ent)
    if x0 == nil or y0 == nil or x1 == nil or y1 == nil or alpha == nil or alpha == 0 then return end

    local plrwpn = entity.get_player_weapon(ent)
    iClip1 = entity.get_prop(plrwpn, "m_iClip1")

    if ui.get(ammo_ref) and iClip1 ~= -1 then
        y1 = y1 + 5
    end

    if ui.get(distance_ref) then
        y1 = y1 + 6
    end

    if ui.get(weapon_text_ref) then
        y1 = y1 + 11
    end

    if ui.get(weapon_icon_ref) then
        y1 = y1 + 16
    end

    local r, g, b, a = ui.get(old_weapon_icons_clr)
    a = a * alpha

    local weapon_char = get_icon_for_weapon_index(plrwpn)
    if weapon_char == nil then return end

    local text, font = "nil", weapon_icons_font

    if weapon_char:len() > 1 then 
        font = weapon_text_font
    else
        font = weapon_icons_font
    end

    local tw,th = renderer.get_text_size(font, weapon_char)
    local middle_x = ((x0 - x1) / 2) + x1 - tw/2
    renderer.draw_text(middle_x, y1 + 1, r, g, b, a * alpha, font, weapon_char)
end

local function draw_name(ent)

    local x0, y0, x1, y1, alpha = entity.get_bounding_box(ent)
    if x0 == nil or y0 == nil or x1 == nil or y1 == nil or alpha == nil or alpha == 0 then
        return
    end

    local r, g, b, a = ui.get(old_name_clr)
    a = a * alpha
    local name = entity.get_player_name(ent)
    if name == nil then return end

    if name:len() > 15 then 
        name = name:sub(0, 15)
    end

    local font = ui.get(old_name_font) == "Normal" and normal_font or bold_font

    local wide, tall = renderer.get_text_size(font, name)

    local middle_x = (x0 - x1) / 2
    x0 = x0 - wide / 2
    renderer.draw_text(x0 - middle_x, y0-tall, r, g, b, a, font, name)
end

local function draw_old_dropped_weapon_esp(ent, entptr)
    local epx, epy, epz = entity.get_prop(ent, "m_vecOrigin")
    local lpx, lpy, lpz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
    if epx == 0 and epy == 0 and epz == 0 then return end
    local wx, wy = renderer.world_to_screen(epx, epy, epz)

    if entptr == nil then return end

    local get_ccs_weapon_info = ffi.cast("get_ccs_weapon_info_t", entptr[0][459])
    local ccsweaponinfo = get_ccs_weapon_info(entptr)

    local iClip1 = entity.get_prop(ent, "m_iClip1")
    local iMaxClip1 = tonumber(ccsweaponinfo.iMaxClip1)

    local weapon_char = get_icon_for_weapon_index(ent)
    if weapon_char == nil then 
        weapon_char = renderer.localize_string(ccsweaponinfo.szHudName):upper()
    end

    local r,g,b,a = ui.get(dropped_weapon_esp_color)

    local ammo_percentage = math.min(1, iMaxClip1 == 0  and 1 or iClip1/iMaxClip1)

    local font = weapon_icons_font
    if weapon_char:len() > 1 then 
        font = weapon_text_font
    else
        font = weapon_icons_font
    end

    if wx ~= nil then

        local tw,th = renderer.get_text_size(font, weapon_char)

        local dist = round_to_fifth(get_distance_in_feet(lpx, lpy, lpz, epx, epy, epz)) .. "FT"
        local dw, dh = renderer.get_text_size(weapon_text_font, dist)

        renderer.draw_text(wx - (dw*.5), wy, r, g, b, a, weapon_text_font, dist)

        local old_wy = wy
        if font == weapon_icons_font then 
            wy = wy - (dh*.5)
        end 

        renderer.draw_text(wx - (tw*.5), wy + dh, r, g, b, a, font, weapon_char)

        wy = old_wy

        if font == weapon_text_font then 
            wy = wy + dh
        end 

        if ui.get(dropped_weapon_ammo_esp_checkbox) and iClip1 ~= -1 then 
            local width = tw * ammo_percentage
            local r,g,b,a = ui.get(dropped_weapon_ammo_esp_color)
            renderer.draw_filled_rect(wx - (tw*.5),       wy + th,       tw + 1, 4, 0, 0, 0, 200)
            renderer.draw_filled_rect(wx - (tw*.5) + 1, wy + th + 1, width - 1, 2, r, g, b, a)
        end
    end
end

client.set_event_callback("paint", function()
    for player=1, globals.maxplayers() do
        if entity.get_classname(player) == "CCSPlayer" and ((not entity.is_enemy(player) and ui.get(teammates_ref)) or entity.is_enemy(player)) and entity.is_alive(player) then
            if ui.get(old_weapon_icons) then
                draw_weapon_icons(player)
            end
            if ui.get(old_name) then
                draw_name(player)
            end
        end
    end
    for i=1, get_highest_entity_by_index(ientitylist) do 
        local rawent = get_client_entity(ientitylist, i)
        if rawent ~= nil then 
            local ent = ffi.cast(ffi.typeof("void***"), rawent)
            if ent ~= nil then 
                local classname = entity.get_classname(i)
                if classname:find("CWeapon") 
                    or classname:find("CAK") 
                    or classname:find("CC4") 
                    or classname:find("Grenade") 
                    or classname:find("Flashbang") 
                    or classname:find("CDEagle") then 
                    local is_weapon = ffi.cast("is_weapon_t", ent[0][165])
                    if is_weapon(ent) then 
                        if ui.get(dropped_weapon_esp_checkbox) then 
                            draw_old_dropped_weapon_esp(i, ent)
                        end
                    end
                end
            end
        end
    end
end)
