local ffi = require("ffi")
ffi.cdef[[
    typedef void(__thiscall* dispatch_user_message_t)(void*, int, int, int, void*); // 38
    typedef bool(__thiscall* is_ingame_t)(void*); // 26
]]
local baseclient = ffi.cast(ffi.typeof("void***"), client.create_interface("client_panorama.dll", "VClient018"))
local engineclient = ffi.cast(ffi.typeof("void***"), client.create_interface("engine.dll", "VEngineClient014"))
local dispatch_user_messasge = ffi.cast("dispatch_user_message_t", baseclient[0][38])
local is_ingame = ffi.cast("is_ingame_t", engineclient[0][26])

client.set_event_callback("paint", function(ctx)
    if is_ingame(engineclient) and client.key_state(0x09) then 
        dispatch_user_messasge(baseclient, 0x32, 0, 0, nil)
    end
end)
