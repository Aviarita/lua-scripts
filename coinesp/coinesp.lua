local ffi = require("ffi")

ffi.cdef[[
    struct glow_object_definition_t {
        void *m_ent;
        float r;
        float g;
        float b;
        float a;
        char pad0x4[4];
        float unk1;
        char pad0x8[8];
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
    typedef int(__thiscall* get_highest_entity_by_index_t)(void*);
]]

local ientitylist = ffi.cast(ffi.typeof("void***"), client.create_interface("client_panorama.dll", "VClientEntityList003"))
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3])
local get_highest_entity_by_index = ffi.cast("get_highest_entity_by_index_t", ientitylist[0][6])

local glow_object_manager = ffi.cast("struct c_glow_object_mngr**", ffi.cast("char*", client.find_signature("client_panorama.dll", "\x0F\x11\x05\xCC\xCC\xCC\xCC\x83\xC8\x01") ) + 3)[0]
client.set_event_callback("paint", function(ctx)
    local coinEnts = {}

    for i=1, get_highest_entity_by_index(ientitylist) do 
        local classname = entity.get_classname(i) 
        if classname == "CDynamicProp" then 
            local materials = materialsystem.get_model_materials(i)
            for j=1, #materials do 
                local model = materials[j]:get_name()
                if model:find("coop/challenge_coin") then 
                    table.insert(coinEnts, get_client_entity(ientitylist, i))
                    local pos = {entity.get_prop(i, "m_vecOrigin")}
                    if pos[1] ~= nil and pos[1] ~= 0 then 
                        local wx, wy = renderer.world_to_screen(pos[1], pos[2], pos[3])
                        if wx ~= nil then 
                            renderer.text(wx, wy, 255, 255, 255, 255, "c-", 999, "COIN")
                        end
                    end
                end
            end
        end
    end

    if #coinEnts > 1 then 
        for j=1, #coinEnts do 
            for i=0, glow_object_manager.m_size do 
                if glow_object_manager.m_glow_object_definitions[i].m_next_free_slot == -2 and glow_object_manager.m_glow_object_definitions[i].m_ent then 
                    local glowobject = ffi.cast("struct glow_object_definition_t&", glow_object_manager.m_glow_object_definitions[i])
                    if glowobject.m_ent == coinEnts[j] then 
                        glowobject.r = 1
                        glowobject.g = 1
                        glowobject.b = 1
                        glowobject.a = 0.7
                        glowobject.m_style = 0
                        glowobject.m_render_when_occluded = true
                        glowobject.m_render_when_unoccluded = false
                    end 
                end
            end
        end
    end
    coinEnts = {}
end)
