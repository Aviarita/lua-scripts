local ffi = require("ffi")

ffi.cdef[[
    typedef struct {
		void* pad[5];
		void* steam_user_stats; // 5
    } steam_ctx_t;

    typedef bool(__thiscall* get_stat_t)(void*, const char*, int32_t*);
    typedef bool(__thiscall* set_stat_t)(void*, const char*, int32_t);
    typedef bool(__thiscall* store_stats_t)(void*);

    typedef const char*(__thiscall* get_command_line_t)(void*);
]]

local isystem = ffi.cast(ffi.typeof("void***"), client.create_interface("vgui2.dll", "VGUI_System010"))
local get_command_line = ffi.cast("get_command_line_t", isystem[0][23])

if not ffi.string(get_command_line(isystem)):find("-insecure") then 
    error("-insecure wasnt detected, stopping the cheat from loading the lua")
end

local steam_ctx_match = client.find_signature("client_panorama.dll", "\xFF\x15\xCC\xCC\xCC\xCC\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x6A") or error("steam_ctx")
local steam_ctx = ffi.cast("steam_ctx_t**", ffi.cast("char*", steam_ctx_match) + 7)[0] or error("steam_ctx not found")
local steam_user_stats = steam_ctx.steam_user_stats
local steam_user_stats_vtable = ffi.cast("void***", steam_user_stats)[0] or error("steam_user_stats error")

local get_stat = ffi.cast("get_stat_t", steam_user_stats_vtable[2])
local set_stat = ffi.cast("set_stat_t", steam_user_stats_vtable[4])
local store_stats = ffi.cast("store_stats_t", steam_user_stats_vtable[10])

local stats = {
    "GI_lesson_Csgo_cycle_weapons_kb",
    "GI_lesson_bomb_sites_A",
    "GI_lesson_bomb_sites_B",
    "GI_lesson_csgo_instr_explain_bomb_carrier",
    "GI_lesson_csgo_instr_explain_buyarmor",
    "GI_lesson_csgo_instr_explain_buymenu",
    "GI_lesson_csgo_instr_explain_follow_bomber",
    "GI_lesson_csgo_instr_explain_inspect",
    "GI_lesson_csgo_instr_explain_pickup_bomb",
    "GI_lesson_csgo_instr_explain_plant_bomb",
    "GI_lesson_csgo_instr_explain_prevent_bomb_pickup",
    "GI_lesson_csgo_instr_explain_reload",
    "GI_lesson_csgo_instr_explain_zoom",
    "GI_lesson_defuse_planted_bomb",
    "GI_lesson_find_planted_bomb",
    "GI_lesson_tr_explain_plant_bomb",
    "GI_lesson_version_number",
    "last_match_contribution_score",
    "last_match_ct_wins",
    "last_match_damage",
    "last_match_deaths",
    "last_match_favweapon_hits",
    "last_match_favweapon_id",
    "last_match_favweapon_kills",
    "last_match_favweapon_shots",
    "last_match_kills",
    "last_match_max_players",
    "last_match_money_spent",
    "last_match_mvps",
    "last_match_rounds",
    "last_match_t_wins",
    "last_match_wins",
    "total_contribution_score",
    "total_damage_done",
    "total_deaths",
    "total_defused_bombs",
    "total_gg_matches_played",
    "total_gun_game_rounds_played",
    "total_gun_game_rounds_won",
    "total_hits_ak47",
    "total_hits_aug",
    "total_hits_bizon",
    "total_hits_deagle",
    "total_hits_famas",
    "total_hits_fiveseven",
    "total_hits_g3sg1",
    "total_hits_galilar",
    "total_hits_glock",
    "total_hits_hkp2000",
    "total_hits_m249",
    "total_hits_m4a1",
    "total_hits_mac10",
    "total_hits_mag7",
    "total_hits_mp7",
    "total_hits_mp9",
    "total_hits_negev",
    "total_hits_nova",
    "total_hits_p250",
    "total_hits_p90",
    "total_hits_sg556",
    "total_hits_ssg08",
    "total_hits_ump45",
    "total_hits_xm1014",
    "total_kills",
    "total_kills_against_zoomed_sniper",
    "total_kills_ak47",
    "total_kills_aug",
    "total_kills_bizon",
    "total_kills_deagle",
    "total_kills_enemy_blinded",
    "total_kills_famas",
    "total_kills_fiveseven",
    "total_kills_g3sg1",
    "total_kills_galilar",
    "total_kills_glock",
    "total_kills_headshot",
    "total_kills_hkp2000",
    "total_kills_m249",
    "total_kills_m4a1",
    "total_kills_mac10",
    "total_kills_mp7",
    "total_kills_mp9",
    "total_kills_negev",
    "total_kills_nova",
    "total_kills_p250",
    "total_kills_p90",
    "total_kills_sg556",
    "total_kills_ssg08",
    "total_kills_ump45",
    "total_kills_xm1014",
    "total_matches_played",
    "total_matches_won",
    "total_money_earned",
    "total_mvps",
    "total_planted_bombs",
    "total_rounds_map_cs_italy",
    "total_rounds_map_de_cbble",
    "total_rounds_map_de_dust2",
    "total_rounds_map_de_nuke",
    "total_rounds_map_de_train",
    "total_rounds_played",
    "total_shots_ak47",
    "total_shots_aug",
    "total_shots_awp",
    "total_shots_bizon",
    "total_shots_deagle",
    "total_shots_famas",
    "total_shots_fired",
    "total_shots_fiveseven",
    "total_shots_g3sg1",
    "total_shots_galilar",
    "total_shots_glock",
    "total_shots_hit",
    "total_shots_hkp2000",
    "total_shots_m249",
    "total_shots_m4a1",
    "total_shots_mac10",
    "total_shots_mag7",
    "total_shots_mp7",
    "total_shots_mp9",
    "total_shots_negev",
    "total_shots_nova",
    "total_shots_p250",
    "total_shots_p90",
    "total_shots_sawedoff",
    "total_shots_scar20",
    "total_shots_sg556",
    "total_shots_ssg08",
    "total_shots_ump45",
    "total_shots_xm1014",
    "total_time_played",
    "total_weapons_donated",
    "total_wins",
    "total_wins_map_cs_italy",
    "total_wins_map_de_cbble",
    "total_wins_map_de_dust2",
    "total_wins_map_de_nuke",
    "total_wins_map_de_train",
    "total_wins_pistolround"
}

ui.new_button("lua", "b", "Get stats", function()
    for i=1, #stats do 
        local data = ffi.new("int32_t[1]")
        if get_stat(steam_user_stats, stats[i], data) then
            print(stats[i] .. " : " .. data[0])
        end
    end
end)

local show_stat_changer = ui.new_checkbox("lua", "b", "Show stat changer")

local sliders = {}
for i=1, #stats do 
    local data = ffi.new("int32_t[1]")
    if get_stat(steam_user_stats, stats[i], data) then
        local slider = ui.new_slider("lua", "b", stats[i], 0, 999999, data[0])
        table.insert(sliders, slider)
    end
end

for i=1, #sliders do 
    ui.set_callback(sliders[i], function(self)
        local name = ui.name(self)
        local value = ui.get(self)
        set_stat(steam_user_stats, name, value)
        store_stats(steam_user_stats)
    end)
end

for i=1, #sliders do 
    ui.set_visible(sliders[i], ui.get(show_stat_changer))
end
ui.set_callback(show_stat_changer, function(self)
    for i=1, #sliders do 
        ui.set_visible(sliders[i], ui.get(self))
    end
end)
