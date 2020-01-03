local ffi = require("ffi")

ffi.cdef[[
    typedef unsigned char wchar_t;

    typedef struct {
		void* pad[5];
		void* steam_user_stats; // 5
    } achievements_unlocker_steam_ctx_t;

    typedef bool(__thiscall* get_achievement_t)(void*, const char*, bool*); // 6
    typedef bool(__thiscall* set_achievement_t)(void*, const char*); // 7
    typedef bool(__thiscall* clear_achievement_t)(void*, const char*); // 8
    typedef bool(__thiscall* store_stats_t)(void*); // 10
    typedef uint32_t(__thiscall* get_num_achievements_t)(void*); // 14
    typedef const char*(__thiscall* get_achievement_name_t)(void*, uint32_t); // 15

    typedef wchar_t*(__thiscall* find_safe_t)(void*, const char*);
    typedef int(__thiscall* convert_unicode_to_ansi_t)(void*, const wchar_t*, char*, int);

    typedef const char*(__thiscall* get_command_line_t)(void*);
]]

local isystem = ffi.cast(ffi.typeof("void***"), client.create_interface("vgui2.dll", "VGUI_System010"))
local get_command_line = ffi.cast("get_command_line_t", isystem[0][23])

-- DO NOT EDIT THIS LINE AS THE STATS CHANGER MAY CAUSE VAC BANS WHEN USED OUTSIDE OF THE INSECURE MODE
if not ffi.string(get_command_line(isystem)):find("-insecure") then 
    error("-insecure wasnt detected, stopping the cheat from loading the lua")
end


local steam_ctx_match = client.find_signature("client_panorama.dll", "\xFF\x15\xCC\xCC\xCC\xCC\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x6A") or error("steam_ctx")
local steam_ctx = ffi.cast("achievements_unlocker_steam_ctx_t**", ffi.cast("char*", steam_ctx_match) + 7)[0] or error("steam_ctx not found")
local steam_user_stats = steam_ctx.steam_user_stats
local steam_user_stats_vtable = ffi.cast("void***", steam_user_stats)[0] or error("steam_user_stats error")

local get_achievement = ffi.cast("get_achievement_t", steam_user_stats_vtable[6])
local set_achievement = ffi.cast("set_achievement_t", steam_user_stats_vtable[7])
local clear_achievement = ffi.cast("clear_achievement_t", steam_user_stats_vtable[8])
local store_stats = ffi.cast("store_stats_t", steam_user_stats_vtable[10])
local get_num_achievements = ffi.cast("get_num_achievements_t", steam_user_stats_vtable[14])
local get_achievement_name = ffi.cast("get_achievement_name_t", steam_user_stats_vtable[15])

local localize = ffi.cast(ffi.typeof('void***'), client.create_interface("localize.dll", "Localize_001")) 

local find_safe = ffi.cast("find_safe_t", localize[0][12])
local convert_unicode_to_ansi = ffi.cast("convert_unicode_to_ansi_t", localize[0][16])

local function get_localized_string(text)
    text = "#" .. text .. "_NAME"
    local localized_string = find_safe(localize, text)
    local char_buffer = ffi.new('char[1024]')  
    convert_unicode_to_ansi(localize, localized_string, char_buffer, 1024)
    return ffi.string(char_buffer)
end

ui.new_button("lua", "b", "Get Achievements", function()
    local num = get_num_achievements(steam_user_stats)
    for i=0, num do 
        local name = ffi.string(get_achievement_name(steam_user_stats, i))
        if name:len() > 2 then 
            local localized_name = get_localized_string(name)
            local unlocked = ffi.new("bool[1]")
            get_achievement(steam_user_stats, name, unlocked)
            print(localized_name .. " (" .. name .. ") : unlocked: ", unlocked[0])
        end
    end
end)

ui.new_button("lua", "b", "Unlock Achievements", function()
    local num = get_num_achievements(steam_user_stats)
    for i=0, num do 
        local name = ffi.string(get_achievement_name(steam_user_stats, i))
        local unlocked = ffi.new("bool[1]")
        get_achievement(steam_user_stats, name, unlocked)
        if not unlocked[0] then 
            set_achievement(steam_user_stats, name)
        end
    end
    store_stats(steam_user_stats)
    print("Successfully unlocked all achievements")
end)

ui.new_button("lua", "b", "Lock Achievements", function()
    local num = get_num_achievements(steam_user_stats)
    for i=0, num do 
        local name = ffi.string(get_achievement_name(steam_user_stats, i))
        local unlocked = ffi.new("bool[1]")
        get_achievement(steam_user_stats, name, unlocked)
        if unlocked[0] then 
            clear_achievement(steam_user_stats, name)
        end
    end
    store_stats(steam_user_stats)
    print("Successfully locked all achievements")
end)
