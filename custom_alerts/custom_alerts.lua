local ffi = require("ffi")

ffi.cdef[[
    typedef void***(__thiscall* FindHudElement_t)(void*, const char*);
    typedef void( __thiscall* ShowAlert_t)( void*, const char*, int );
    typedef void( __thiscall* HidePanel_t)( void*, bool );

    struct CHudElement {
        char pad0x20[0x20];
        const char* m_pName;
    };
]]

local match = client.find_signature("client_panorama.dll", "\xB9\xCC\xCC\xCC\xCC\x88\x46\x09") or error("Hud not found")
local char_match = ffi.cast("char*", match) + 1 
local hud = ffi.cast("void**", char_match)[0] or error("hud is nil")

match = client.find_signature("client_panorama.dll", "\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28") or error("FindHudElement not found")
local find_hud_element = ffi.cast("FindHudElement_t", match)

local alerts = find_hud_element(hud, "CCSGO_HudUniqueAlerts") or error("Couldn't find CCSGO_HudUniqueAlerts")

local function GetPanel2D(hudelement)
    return ffi.cast("void***", ffi.cast("char*", hudelement) - 0x14)
end 

local function ShowAlert(panel, text, mode)
    local thisptr = GetPanel2D(panel)
    local match = client.find_signature("client_panorama.dll", "\x55\x8B\xEC\xA1\xCC\xCC\xCC\xCC\x83\xEC\x08\x56\x8B\xF1\x57\xA8\x01\x75\x26\x8B\x0D\xCC\xCC\xCC\xCC\x83\xC8\x01\xA3\xCC\xCC\xCC\xCC\x68\xCC\xCC\xCC\xCC\x8B\x01\xFF\x90\xCC\xCC\xCC\xCC\x66\xA3\xCC\xCC\xCC\xCC\xA1") or error("ShowAlert not found")
    local fn = ffi.cast("ShowAlert_t", match)
    fn(thisptr, text, mode)
end

local function follow_relative_jump(address)
    return ffi.cast("uintptr_t", ffi.cast("uintptr_t*", ffi.cast("char*", address) + 1)[0] + ffi.cast("uintptr_t",  ffi.cast("char*", address) + 5))
end

local function HidePanel(panel)
    local thisptr = GetPanel2D(panel)
    local match = client.find_signature("client_panorama.dll", "\xE8\xCC\xCC\xCC\xCC\x5F\x5E\x5B\x8B\xE5\x5D\xC2\x04\x00\x8B\xD3\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x85\xC0\x0F\x85\xCC\xCC\xCC\xCC\x8B\x44\x24\x14") or error("HidePanel not found")
    local fn = ffi.cast("HidePanel_t", follow_relative_jump(match))
    fn(thisptr, false)
end

local alerts_mt = {}
alerts_mt.__index = alerts_mt

local function create_alert(text)
    local panel = find_hud_element(hud, "CCSGO_HudUniqueAlerts") or error("Couldn't find CCSGO_HudUniqueAlerts")

    alerts_mt.panel = panel
    alerts_mt.text = text

    alerts_mt.show = function()
        local thisptr = GetPanel2D(alerts_mt.panel)
        local match = client.find_signature("client_panorama.dll", "\x55\x8B\xEC\xA1\xCC\xCC\xCC\xCC\x83\xEC\x08\x56\x8B\xF1\x57\xA8\x01\x75\x26\x8B\x0D\xCC\xCC\xCC\xCC\x83\xC8\x01\xA3\xCC\xCC\xCC\xCC\x68\xCC\xCC\xCC\xCC\x8B\x01\xFF\x90\xCC\xCC\xCC\xCC\x66\xA3\xCC\xCC\xCC\xCC\xA1") or error("ShowAlert not found")
        local fn = ffi.cast("ShowAlert_t", match)
        fn(thisptr, alerts_mt.text, 1)
    end

    alerts_mt.hide = function()
        local thisptr = GetPanel2D(alerts_mt.panel)
        local match = client.find_signature("client_panorama.dll", "\xE8\xCC\xCC\xCC\xCC\x5F\x5E\x5B\x8B\xE5\x5D\xC2\x04\x00\x8B\xD3\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x85\xC0\x0F\x85\xCC\xCC\xCC\xCC\x8B\x44\x24\x14") or error("HidePanel not found")
        local fn = ffi.cast("HidePanel_t", follow_relative_jump(match))
        fn(thisptr, false)
    end
    return setmetatable({}, alerts_mt)
end

return {
    create_alert = create_alert
}
