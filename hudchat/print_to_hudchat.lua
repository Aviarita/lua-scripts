local ffi = require("ffi")
ffi.cdef[[
    // create cdata typedef 
    typedef void***(__thiscall* FindHudElement_t)(void*, const char*);
    typedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);
]]


local signature_gHud = "\xB9\xCC\xCC\xCC\xCC\x88\x46\x09"
local signature_FindElement = "\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28"

-- find signature_gHud in client_panorama.dll
local match = client.find_signature("client_panorama.dll", signature_gHud) or error("sig1 not found") -- returns void***
-- cast the match from find_signature to a char* so it can be used for addition and add 1 to it
local char_match = ffi.cast("char*", match) + 1 
-- cast match + 1 back to a void***, so it can be dereferenced to get its vtable
local hud = ffi.cast("void**", char_match)[0] or error("hud is nil") -- returns void**

-- find signature_FindElement in client_panorama.dll
match = client.find_signature("client_panorama.dll", signature_FindElement) or error("FindHudElement not found")
-- cast the lightuserdata to a type that we can dereference
local find_hud_element = ffi.cast("FindHudElement_t", match)
-- use the returned cfunc find_hud_element with the parameter hud and "CHudChat" to get the CHudChat class pointer
local hudchat = find_hud_element(hud, "CHudChat") or error("CHudChat not found")
-- dereference the pointer to get its vtable
local chudchat_vtbl = hudchat[0] or error("CHudChat instance vtable is nil")

-- vtable is an array of functions, the 27th is ChatPrintf
local raw_print_to_chat = chudchat_vtbl[27] -- void*

-- cast the function pointer to a callable type
local print_to_chat = ffi.cast('ChatPrintf_t', raw_print_to_chat)

--[[
\x01 - white
\x02 - red
\x03 - purple
\x04 - green
\x05 - yellow green
\x06 - light green
\x07 - light red
\x08 - gray
\x09 - light yellow
\x0A - gray
\x0C - dark blue
\x10 - gold
]]

print_to_chat(hudchat, entity.get_local_player(), 0, " \x02".."dank memes")
