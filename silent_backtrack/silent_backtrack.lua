local ffi = require("ffi")
ffi.cdef [[
    struct vec3_t_ahubsdfgguhinadfiuhnuiadnfhhhnhahuhfdn {
		float x; float y; float z;	
    };
]]

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(ffi.typeof("void***"), rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast(ffi.typeof("void*(__thiscall*)(void*, int)"), ientitylist[0][3]) or error("get_client_entity is nil", 2)

local f = ffi.typeof("void( __thiscall*)(void*, const struct vec3_t_ahubsdfgguhinadfiuhnuiadnfhhhnhahuhfdn&)")
local fn = ffi.cast(f, client.find_signature("client_panorama.dll", "\x55\x8B\xEC\x83\xE4\xF8\x51\x53\x56\x57\x8B\xF1\xE8"))
local function set_abs_origin(entity, x, y, z)
    local pos = ffi.new("struct vec3_t_ahubsdfgguhinadfiuhnuiadnfhhhnhahuhfdn")
    pos.x = x  pos.y = y pos.z = z
    fn(entity, pos)
end

local silent_backtrack = ui.new_checkbox("visuals", "effects", "Silent backtrack")

local _set, _unset = client.set_event_callback, client.unset_event_callback

local positions = {}
local function net_update_start()
    for _, entidx in pairs(entity.get_players(true)) do
        positions[entidx] = {entity.get_prop(entidx, "m_vecOrigin")}
    end
end

local function player_death(event) 
    local opfer = client.userid_to_entindex(event.userid)
    local attacker = client.userid_to_entindex(event.attacker)
    if attacker ~= entity.get_local_player() then
       return
    end
    local x2, y2, z2 = unpack(positions[opfer])
    client.delay_call(0.00001, function()
        local ragdolls = entity.get_all("CCSRagdoll")
        for i = 1, #ragdolls do
            local ragdoll = ragdolls[i]
            local m_hPlayer = entity.get_prop(ragdoll, "m_hPlayer")
            if m_hPlayer == opfer then
                local ragdoll_entity = get_client_entity(ientitylist, ragdoll)
                if ragdoll_entity ~= nil then
                    local x, y, z = entity.get_prop(ragdoll, "m_vecOrigin")
                    set_abs_origin(ragdoll_entity, x2, y2, z2)
                end
            end
        end
    end)
end

ui.set_callback(silent_backtrack, function(self)
    local fn = ui.get(self) and _set or _unset 
    fn("net_update_start", net_update_start)
    fn("player_death", player_death)
end)
