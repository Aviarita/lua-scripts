local ffi = require("ffi")

ffi.cdef[[
    struct vec3_t {
		float x;
		float y;
		float z;	
    };
        
    struct ColorRGBExp32{
        unsigned char r, g, b;
        signed char exponent;
    };
    
    struct dlight_t {
        int flags;
        struct vec3_t origin;
        float radius;
        struct ColorRGBExp32 color;
        float die;
        float decay;
        float minlight;
        int key;
        int style;
        struct vec3_t direction;
        float innerAngle;
        float outerAngle;
    };

    enum DlightFlags {
        DLIGHT_NO_WORLD_ILLUMINATION = 0x1,
        DLIGHT_NO_MODEL_ILLUMINATION = 0x2,
    };

    typedef bool(__thiscall* is_weapon_t)(void*);
]]

local function uuid(len)
    local res, len = "", len or 32
    for i=1, len do
        res = res .. string.char(client.random_int(97, 122))
    end
    return res
end

local interface_mt = {}

function interface_mt.get_function(self, index, ret, args)
    local ct = uuid() .. "_t"

    args = args or {}
    if type(args) == "table" then
        table.insert(args, 1, "void*")
    else
        return error("args has to be of type table", 2)
    end
    local success, res = pcall(ffi.cdef, "typedef " .. ret .. " (__thiscall* " .. ct .. ")(" .. table.concat(args, ", ") .. ");")
    if not success then
        error("invalid typedef: " .. res, 2)
    end

    local interface = self[1]
    local success, func = pcall(ffi.cast, ct, interface[0][index])
    if not success then
        return error("failed to cast: " .. func, 2)
    end

    return function(...)
        local success, res = pcall(func, interface, ...)

        if not success then
            return error("call: " .. res, 2)
        end

        if ret == "const char*" then
            return res ~= nil and ffi.string(res) or nil
        end
        return res
    end
end

local function create_interface(dll, interface_name)
    local interface = (type(dll) == "string" and type(interface_name) == "string") and client.create_interface(dll, interface_name) or dll
    return setmetatable({ffi.cast(ffi.typeof("void***"), interface)}, {__index = interface_mt})
end

local effects = create_interface("engine.dll", "VEngineEffects001")
local alloc_dlight = effects:get_function(4, "struct dlight_t*", {"int"})
local alloc_elight = effects:get_function(5, "struct dlight_t*", {"int"})
local get_elight_by_key = effects:get_function(8, "struct dlight_t*", {"int"})

local entity_list                   = create_interface("client_panorama.dll", "VClientEntityList003")
local get_client_entity             = entity_list:get_function(3, "void*", {"int"})
local get_highest_entity_by_index   = entity_list:get_function(6, "int")

local class_ptr = ffi.typeof("void***")

local enable_dlights = ui.new_checkbox("visuals", "effects", "Show dlights")
local enable_elights = ui.new_checkbox("visuals", "effects", "Show elights")
local players = {
    dlights = {
        enable = ui.new_checkbox("visuals", "effects", "Player dlights"),
        color = ui.new_color_picker("visuals", "effects", "dlights_color", 255,255,255,80),
        radius = ui.new_slider("visuals", "effects", "\ndlight_radius", 0, 250, 50, true, "ft"),
        style = ui.new_slider("visuals", "effects", "\ndlight_style", 1, 11, 1)
    },
    elights = {
        enable = ui.new_checkbox("visuals", "effects", "Player elights"),
        color = ui.new_color_picker("visuals", "effects", "elights_color", 255,255,255,80),
        style = ui.new_slider("visuals", "effects", "\nelight_style", 1, 11, 1)
    }
}
local entites = {
    dlights = {
        enable = ui.new_checkbox("visuals", "effects", "Entity dlights"),
        color = ui.new_color_picker("visuals", "effects", "dlights_color", 255,255,255,80),
        radius = ui.new_slider("visuals", "effects", "\ndlight_radius", 0, 250, 50, true, "ft"),
        style = ui.new_slider("visuals", "effects", "\ndlight_style", 1, 11, 1)
    }
}

for i,v in pairs(players.dlights) do
    ui.set_visible(v, false)
end
for i,v in pairs(players.elights) do
    ui.set_visible(v, false)
end
for i,v in pairs(entites.dlights) do
    ui.set_visible(v, false)
end

ui.set_callback(enable_dlights, function(self)
    local state = ui.get(self)
    for i,v in pairs(players.dlights) do
        ui.set_visible(v, state)
    end
    for i,v in pairs(entites.dlights) do
        ui.set_visible(v, state)
    end
end)
ui.set_callback(enable_elights, function(self)
    local state = ui.get(self)
    for i,v in pairs(players.elights) do
        ui.set_visible(v, state)
    end
end)

local function draw_dlight(settings)
    local dlight = alloc_dlight(settings.index)
    dlight.key = settings.index

    dlight.color.r = settings.clr[1]
    dlight.color.g = settings.clr[2]
    dlight.color.b = settings.clr[3]
    dlight.color.exponent = settings.clr[4] / 8.5

    dlight.flags = settings.flags

    dlight.style = settings.stl

    dlight.direction = settings.pos
    dlight.origin = settings.pos

    dlight.radius = settings.rad

    dlight.die = globals.curtime() + 0.1
    
    dlight.decay = settings.rad / 5
end
local function draw_elight(settings)
    local elight = alloc_elight(settings.index)
    elight.key = settings.index
    elight.color.r = settings.clr[1]
    elight.color.g = settings.clr[2]
    elight.color.b = settings.clr[3]
    elight.color.exponent = settings.clr[4] / 8.5
    elight.flags = 0
    elight.style = settings.stl
    elight.direction = settings.pos
    elight.origin = settings.pos
    elight.radius = settings.rad
    elight.die = globals.curtime() + 0.1
    elight.decay = settings.rad / 5
end

client.set_event_callback("paint", function(ctx)

    local dli = {
        clr = {ui.get(players.dlights.color)},
        rad = ui.get(players.dlights.radius),
        stl = ui.get(players.dlights.style)
    }
    local eli = {
        clr = {ui.get(players.elights.color)},
        rad = 75,
        stl = ui.get(players.elights.style)
    }

    local pos = ffi.new("struct vec3_t")

    local niggers = entity.get_players(true)
    for i=1, #niggers do 
        local ent = niggers[i]

        if ui.get(players.dlights.enable) then
            local pos_l = {entity.get_prop(ent, "m_vecOrigin")}
            pos.x = pos_l[1] 
            pos.y = pos_l[2] 
            pos.z = pos_l[3]

            local settings = {
                index = ent,
                clr = dli.clr,
                flags = 0x2,
                stl = dli.stl,
                pos = pos,
                rad = dli.rad
            }
            draw_dlight(settings)
        end

        if ui.get(players.elights.enable) then
            local pos_l = {entity.hitbox_position(ent, 0)}
            pos_l[3] = pos_l[3] + 35
            pos.x = pos_l[1] 
            pos.y = pos_l[2] 
            pos.z = pos_l[3]

            local settings = {
                index = ent,
                clr = eli.clr,
                flags = 0,
                stl = eli.stl,
                pos = pos,
                rad = eli.rad
            }
            draw_elight(settings)
        end
    end

    local dli = {
        clr = {ui.get(entites.dlights.color)},
        rad = ui.get(entites.dlights.radius),
        stl = ui.get(entites.dlights.style)
    }
    for i=1, get_highest_entity_by_index() do 
        local rawent = get_client_entity(i)
        local ent = ffi.cast(class_ptr, rawent)
        if ent ~= nil then 
            local is_weapon = ffi.cast("is_weapon_t", ent[0][164])
            if is_weapon(ent) then 
                if ui.get(entites.dlights.enable) then
                    local pos_l = {entity.get_prop(i, "m_vecOrigin")}
                    pos.x = pos_l[1] 
                    pos.y = pos_l[2] 
                    pos.z = pos_l[3]
        
                    local settings = {
                        index = i,
                        clr = dli.clr,
                        flags = 0x2,
                        stl = dli.stl,
                        pos = pos,
                        rad = dli.rad
                    }
                    draw_dlight(settings)
                end
            end
        end
    end
end)