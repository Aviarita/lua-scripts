local ffi = require("ffi")

ffi.cdef[[
    struct glow_object_definition_t {
        void *m_ent;
        float r;
        float g;
        float b;
        float a;
        char pad0x8[8];
        float m_bloom_amount;
        float m_localplayeriszeropoint3;
        bool m_render_when_occluded;
        bool m_render_when_unoccluded;
        bool m_full_bloom_render;
        char pad0x1[1];
        int m_full_bloom_stencil_test_value;
        int m_style;
        int m_split_screen_slot;
        int m_next_free_slot;
    
        static const int END_OF_FREE_LIST = -1;
        static const int ENTRY_IN_USE = -2;
    };
    struct c_glow_object_mngr {
        struct glow_object_definition_t *m_glow_object_definitions;
        int m_max_size;
        int m_pad;
        int m_size;
        struct glow_object_definition_t *m_glow_object_definitions2;
        int m_current_objects;
    }; 
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]

local cast = ffi.cast
local get_players, get_prop, get_local_player, is_alive = entity.get_players, entity.get_prop, entity.get_local_player, entity.is_alive
local get, set, vis = ui.get, ui.set, ui.set_visible
local insert = table.insert

local glow_object_manager_sig = "\x0F\x11\x05\xCC\xCC\xCC\xCC\x83\xC8\x01"
local match = client.find_signature("client_panorama.dll", glow_object_manager_sig) or error("sig not found")
local glow_object_manager = cast("struct c_glow_object_mngr**", cast("char*", match) + 3)[0] or error("glow_object_manager is nil")

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = cast(ffi.typeof("void***"), rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local teammates = ui.reference("visuals", "player esp", "Teammates")
local glow, glow_clr = ui.reference("visuals", "player esp", "Glow")
local c_glow = ui.new_combobox("visuals", "player esp", "Custom glow", "Off", "Default", "Health based")
local c_glow_clr = ui.new_color_picker("visuals", "player esp", "Custom glow color", 180, 60, 120, 170)
local c_glow_style = ui.new_combobox("visuals", "player esp", "\nglow style", {
    "Normal",
    "Overlay pulse",
    "Inline",
    "Inline pulse"
})

local styles = {
    ["Normal"] = 0,
    ["Overlay pulse"] = 1,
    ["Inline"] = 2,
    ["Inline pulse"] = 3
}

local clr = {}
clr.r, clr.g, clr.b, clr.a = get(c_glow_clr)
ui.set_callback(c_glow_clr, function(self)
    clr.r, clr.g, clr.b, clr.a = get(self)
    set(glow_clr, get(self))
end)

ui.set_callback(c_glow, function(self)
    set(glow, get(self) == "Default")
    vis(glow, get(self) == "Off")
    vis(glow_clr, get(self) == "Off")
    vis(c_glow_style, get(self) == "Health based")
end)


client.set_event_callback("paint", function(ctx)
    if get(c_glow) == "Health based" then 
        local players = get_players(not get(teammates))
        local me = get_local_player()
        for i=0, glow_object_manager.m_size do 
            if glow_object_manager.m_glow_object_definitions[i].m_next_free_slot == -2 and glow_object_manager.m_glow_object_definitions[i].m_ent then 
                local glowobject = cast("struct glow_object_definition_t&", glow_object_manager.m_glow_object_definitions[i])
                local glowent = glowobject.m_ent
                for i=1, #players do 
                    local player = players[i]
                    if is_alive(player) and player ~= me then 
                        local ent = get_client_entity(ientitylist, player)
                        local health = get_prop(player, "m_iHealth")
                        local red = 255 - (health*2)
                        local green = health*2
                        if glowent == ent then 
                            glowobject.r = red / 255
                            glowobject.g = green / 255
                            glowobject.b = 0
                            glowobject.a = clr.a / 255
                            glowobject.m_style = styles[get(c_glow_style)]
                            glowobject.m_render_when_occluded = true
                            glowobject.m_render_when_unoccluded = false
                        end
                    end
                end
            end
        end
    end
end)
