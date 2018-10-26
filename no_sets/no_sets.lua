local ref = ui.reference
local set = ui.set
local function vis(m) ui.set_visible(m, false) end
local function df(m) set(m, false) vis(m) end

local rage = {
	tab 		= "rage",
	aimbot 		= "aimbot",
	other 		= "other",
}

local function disable_rage_aimbot()
	local ae, ah = ref(rage.tab, rage.aimbot, "enabled") df(ae) vis(ah)
	local sel = ref(rage.tab, rage.aimbot, "target selection") vis(sel)
	local hit = ref(rage.tab, rage.aimbot, "target hitbox") vis(hit)
	local alim = ref(rage.tab, rage.aimbot, "avoid limbs if moving") df(alim)
	local ahij = ref(rage.tab, rage.aimbot, "avoid head if jumping") df(ahij)
	local mp1, mp2, mp3 = ref(rage.tab, rage.aimbot, "multi-point") vis(mp1) vis(mp2) vis(mp3)
	local mp4 = ref(rage.tab, rage.aimbot, "multi-point scale") vis(mp4)
	local mp5 = ref(rage.tab, rage.aimbot, "dynamic multi-point") df(mp5)
	local shs = ref(rage.tab, rage.aimbot, "stomach hitbox scale") vis(shs)
	local af = ref(rage.tab, rage.aimbot, "automatic fire") df(af)
	local ap = ref(rage.tab, rage.aimbot, "automatic penetration") df(ap)
	local sa = ref(rage.tab, rage.aimbot, "silent aim") df(sa)
	local mhc = ref(rage.tab, rage.aimbot, "minimum hit chance") vis(mhc)
	local md = ref(rage.tab, rage.aimbot, "minimum damage") vis(md)
	local oa = ref(rage.tab, rage.aimbot, "override awp") vis(oa)
	local as = ref(rage.tab, rage.aimbot, "automatic scope") vis(as)
	local ras = ref(rage.tab, rage.aimbot, "reduce aim step") vis(ras)
	local mf = ref(rage.tab, rage.aimbot, "maximum fov") vis(mf)
end

local function disable_rage_other()
	local rs = ref(rage.tab, rage.other, "remove spread") df(rs)
	local rr = ref(rage.tab, rage.other, "remove recoil") df(rr)
	local ab = ref(rage.tab, rage.other, "accuracy boost") vis(ab)
	local abo = ref(rage.tab, rage.other, "accuracy boost options") vis(abo)
	local qs, qsh = ref(rage.tab, rage.other, "quick stop") vis(qs) vis(qsh)
	local qpa,qpah = ref(rage.tab, rage.other, "quick peek assist") df(qpa) vis(qpah)
	local aac = ref(rage.tab, rage.other, "anti-aim correction") df(aac)
	local aar = ref(rage.tab, rage.other, "anti-aim resolver") df(aar)
	local aaro, aaroh = ref(rage.tab, rage.other, "anti-aim resolver override" ) df(aaro) vis(aaroh)
	local flc = ref(rage.tab, rage.other, "fake lag correction") vis(flc)
	local pba = ref(rage.tab, rage.other, "prefer body aim") vis(pba)
	local fba = ref(rage.tab, rage.other, "force body aim") vis(fba)
	local dpa = ref(rage.tab, rage.other, "duck peek assist") vis(dpa)
	local dsou = ref(rage.tab, rage.other, "delay shot on unduck") vis(dsou)
	local dt = ref(rage.tab, rage.other, "double tap") vis(dt)
end

local function disable_antiaim_antiaim()
	local pitch = ref("AA", "Anti-aimbot angles", "Pitch") set(pitch, "off") vis(pitch)
	local yawbase = ref("AA", "Anti-aimbot angles", "Yaw base") vis(yawbase)
	local yaw, yawnum = ref("AA", "Anti-aimbot angles", "Yaw") set(yaw, "off") vis(yaw) vis(yawnum)
	local yawjitter, yawjitternum = ref("AA", "Anti-aimbot angles", "Yaw jitter") set(yawjitter, "off") vis(yawjitter) vis(yawjitternum)
	local yawwhilerunning, yawwhilerunningnum = ref("AA", "Anti-aimbot angles", "Yaw while running") set(yawwhilerunning, "off") vis(yawwhilerunning) vis(yawwhilerunningnum)
	local fakeyaw, fakeyawnum = ref("AA", "Anti-aimbot angles", "Fake yaw") set(fakeyaw, "off") vis(fakeyaw) vis(fakeyawnum)
	local edgeyaw = ref("AA", "Anti-aimbot angles", "Edge yaw") set(edgeyaw, "off") vis(edgeyaw)
	local edgeyawnum = ref("aa", "Anti-aimbot angles", "edge fake yaw offset") vis(edgeyawnum)
	local freestanding = ref("AA", "Anti-aimbot angles", "Freestanding") set(freestanding, "-") vis(freestanding)
	local freestanding_real_yawnum = ref("AA", "Anti-aimbot angles", "Freestanding real yaw offset") set(freestanding_real_yawnum, 0) vis(freestanding_real_yawnum)
	local freestanding_fake_yawnum = ref("AA", "Anti-aimbot angles", "Freestanding fake yaw offset") set(freestanding_fake_yawnum, 0) vis(freestanding_fake_yawnum)
	local crooked = ref("AA", "Anti-aimbot angles", "Crooked") df(crooked)
	local twist = ref("AA", "Anti-aimbot angles", "Twist") df(twist)
end

local function disable_antiaim_fakelag()
	local fakelag_enabled, fakelag_hotkey = ref("AA", "Fake lag", "Enabled") df(fakelag_enabled) vis(fakelag_hotkey)
	local fakelag_triggers = ref("AA", "Fake lag", "Triggers") set(fakelag_triggers, "while climbing ladder") vis(fakelag_triggers)
	local fakelag_amount = ref("AA", "Fake lag", "Amount") vis(fakelag_amount)
	local fakelag_variance = ref("AA", "Fake lag", "Variance") vis(fakelag_variance)
	local fakelag_limit = ref("AA", "Fake lag", "Limit") vis(fakelag_limit)
	local fakelag_whileshooting = ref("AA", "Fake lag", "Fake lag while shooting") df(fakelag_whileshooting)
	local fakelag_resetonbhop = ref("AA", "Fake lag", "Reset on bunny hop") df(fakelag_resetonbhop)
	local fakelag_standstill = ref("AA", "Fake lag", "Reset on standstill") df(fakelag_standstill)
	local slowmotion, slowmotion_hotkey = ref("AA", "Other", "Slow motion") df(slowmotion) vis(slowmotion_hotkey)
	local fixlegmovement = ref("AA", "Other", "Fix leg movement") df(fixlegmovement)
end

local legit = {
	tab 		= "legit",
	aimbot 		= "aimbot", 
	triggerbot	= "triggerbot",
	other 		= "other"
}

local function disable_legitbot_aimbot()
	local ae, ah = ref(legit.tab, legit.aimbot, "enabled") df(ae) vis(ah)
	local s = ref(legit.tab, legit.aimbot, "speed") set(s, 1) vis(s)
	local sia = ref(legit.tab, legit.aimbot, "speed (in attack)") set(sia, 1) vis(sia)
	local scf = ref(legit.tab, legit.aimbot, "speed scale - fov") set(scf, 1) vis(scf)
	local mlot = ref(legit.tab, legit.aimbot, "maximum lock-on time") set(mlot, 1) vis(mlot)
	local rt = ref(legit.tab, legit.aimbot, "reaction time") set(rt, 1) vis(rt)
	local mf = ref(legit.tab, legit.aimbot, "maximum fov") set(mf, 1) vis(mf)
	local rcs, rcs2 = ref(legit.tab, legit.aimbot, "recoil compensation (p/y)") set(rcs, 1) vis(rcs) set(rcs2, 1) vis(rcs2)
	local qs = ref(legit.tab, legit.aimbot, "quick stop") df(qs)
	local ats = ref(legit.tab, legit.aimbot, "aim through smoke") df(ats)
	local awb = ref(legit.tab, legit.aimbot, "aim while blind") df(awb)
	local he = ref(legit.tab, legit.aimbot, "head") df(he)
	local ch = ref(legit.tab, legit.aimbot, "chest") df(ch)
	local st = ref(legit.tab, legit.aimbot, "stomach") df(st)
end

local function disable_legitbot_triggerbot()
	local te, teh = ref(legit.tab, legit.triggerbot, "enabled") df(te) vis(teh)
	local mhc = ref(legit.tab, legit.triggerbot, "minimum hit chance") set(mhc, 1) vis(mhc)
	local rt = ref(legit.tab, legit.triggerbot, "reaction time") set(rt, 1) vis(rt)
	local bf = ref(legit.tab, legit.triggerbot, "burst fire") df(bf) 
	local md = ref(legit.tab, legit.triggerbot, "minimum damage") set(md, 1) vis(md)
	local ap = ref(legit.tab, legit.triggerbot, "automatic penetration") df(ap)
	local he = ref(legit.tab, legit.triggerbot, "head") df(he)
	local ch = ref(legit.tab, legit.triggerbot, "chest") df(ch)
	local st = ref(legit.tab, legit.triggerbot, "stomach") df(st)

	local ab = ref(legit.tab, legit.other, "accuracy boost") set(ab, "off") vis(ab)
	local rcs = ref(legit.tab, legit.other, "standalone recoil compensation") df(rcs)
	local fa = ref(legit.tab, legit.other, "fake angles") df(fa)
end

local function disable_visuals_playeresp()
	local activation_type = ref("VISUALS", "Player ESP", "Activation Type") vis(activation_type)
	local teammates =  ref("VISUALS", "Player ESP", "Teammates") df(teammates)
	local dormant = ref("VISUALS", "Player ESP", "Dormant") df(dormant)
	local bounding_box, bounding_box_color = ref("VISUALS", "Player ESP", "Bounding box") df(bounding_box) vis(bounding_box_color)
	local health_bar = ref("VISUALS", "Player ESP", "Health bar") df(health_bar)
	local name, name_color = ref("VISUALS", "Player ESP", "Name") df(name) vis(name_color)
	local flags = ref("VISUALS", "Player ESP", "Flags") df(flags)
	local weapon_text = ref("VISUALS", "Player ESP", "Weapon text") df(weapon_text)
	local weapon_icon, weapon_icon_color = ref("VISUALS", "Player ESP", "Weapon icon") df(weapon_icon) vis(weapon_icon_color)
	local ammo, ammo_color = ref("VISUALS", "Player ESP", "Ammo") df(ammo) vis(ammo_color)
	local distance = ref("VISUALS", "Player ESP", "Distance") df(distance)
	local lby_timer, lby_timer_color = ref("VISUALS", "Player ESP", "LBY timer") df(lby_timer) vis(lby_timer_color)
	local glow, glow_color = ref("VISUALS", "Player ESP", "Glow") df(glow) vis(glow_color)
	local hit_marker = ref("VISUALS", "Player ESP", "Hit marker") df(hit_marker)
	local hit_marker_sound = ref("VISUALS", "Player ESP", "Hit marker sound") df(hit_marker_sound)
	local visualize_sounds, visualize_sounds_color = ref("VISUALS", "Player ESP", "Visualize sounds") df(visualize_sounds) vis(visualize_sounds_color)
	local line_of_sight, line_of_sight_color = ref("VISUALS", "Player ESP", "Line of sight") df(line_of_sight) vis(line_of_sight_color)
	local money = ref("VISUALS", "Player ESP", "Money") df(money)
	local skeleton, skeleton_color = ref("VISUALS", "Player ESP", "Skeleton") df(skeleton) vis(skeleton_color)
	local out_of_fov_arrow, out_of_fov_arrow_color, out_of_fov_arrow_size, out_of_fov_arrow_distance = ref("VISUALS", "Player ESP", "Out of FOV arrow") df(out_of_fov_arrow) vis(out_of_fov_arrow_color) vis(out_of_fov_arrow_size) vis(out_of_fov_arrow_distance)
end

local function disable_visuals_otheresp()
	local radar = ref("VISUALS", "Other ESP", "Radar") df(radar)
	local dropped_weapons_combobox, dropped_weapons_color = ref("VISUALS", "Other ESP", "Dropped weapons") set(dropped_weapons_combobox, "off") vis(dropped_weapons_combobox) vis(dropped_weapons_color)
	local dropped_weapon_ammo = ref("VISUALS", "Other ESP", "Dropped weapon ammo") df(dropped_weapon_ammo)
	local grenades, grenades_color = ref("VISUALS", "Other ESP", "Grenades") df(grenades) vis(grenades_color)
	local inaccuracy_overlay, inaccuracy_overlay_color = ref("VISUALS", "Other ESP", "Inaccuracy overlay") df(inaccuracy_overlay) vis(inaccuracy_overlay_color)
	local recoil_overlay = ref("VISUALS", "Other ESP", "Recoil overlay") df(recoil_overlay)
	local crosshair = ref("VISUALS", "Other ESP", "Crosshair") df(crosshair)
	local bomb, bomb_color = ref("VISUALS", "Other ESP", "Bomb") df(bomb) vis(bomb_color)
	local grenade_trajectory, grenade_trajectory_color = ref("VISUALS", "Other ESP", "Grenade trajectory") df(grenade_trajectory) vis(grenade_trajectory_color)
	local spectators = ref("VISUALS", "Other ESP", "Spectators") df(spectators)
	local penetration_reticle = ref("VISUALS", "Other ESP", "Penetration reticle") df(penetration_reticle)
	local hostages, hostages_color = ref("VISUALS", "Other ESP", "Hostages") df(hostages) vis(hostages_color)
	local shared_esp, shared_esp_hotkey = ref("VISUALS", "Other ESP", "Shared ESP") df(shared_esp) vis(shared_esp_hotkey)
	local shared_esp_with_other_team = ref("VISUALS", "Other ESP", "Shared ESP with other team") df(shared_esp_with_other_team)
	local restrict_shared_esp_updates = ref("VISUALS", "Other ESP", "Restrict shared ESP updates") df(restrict_shared_esp_updates)
end

local function disable_visuals_effects()
	local remove_flashbang_effects = ref("VISUALS", "Effects", "Remove flashbang effects") df(remove_flashbang_effects)
	local remove_smoke_grenades = ref("VISUALS", "Effects", "Remove smoke grenades") df(remove_smoke_grenades)
	local remove_fog = ref("VISUALS", "Effects", "Remove fog") df(remove_fog)
	local visual_recoil_adjustment = ref("VISUALS", "Effects", "Visual recoil adjustment") set(visual_recoil_adjustment, "off") vis(visual_recoil_adjustment)
	local transparent_walls = ref("VISUALS", "Effects", "Transparent walls") set(transparent_walls, 100) vis(transparent_walls)
	local transparent_props = ref("VISUALS", "Effects", "Transparent props") set(transparent_props, 100) vis(transparent_props)
	local brightness_adjustment = ref("VISUALS", "Effects", "Brightness adjustment") set(brightness_adjustment, "off") vis(brightness_adjustment)
	local remove_scope_overlay = ref("VISUALS", "Effects", "Remove scope overlay") df(remove_scope_overlay)
	local instant_scope = ref("VISUALS", "Effects", "Instant scope") df(instant_scope)
	local disable_post_processing = ref("VISUALS", "Effects", "Disable post processing") df(disable_post_processing)
	local force_third_person_alive, force_third_person_alive_hotkey = ref("VISUALS", "Effects", "Force third person (alive)") df(force_third_person_alive) vis(force_third_person_alive_hotkey)
	local force_third_person_dead = ref("VISUALS", "Effects", "Force third person (dead)") df(force_third_person_dead)
	local disable_rendering_of_teammates = ref("VISUALS", "Effects", "Disable rendering of teammates") df(disable_rendering_of_teammates)
	local bullet_tracers, bullet_tracers_color = ref("VISUALS", "Effects", "Bullet tracers") df(bullet_tracers) vis(bullet_tracers_color)
	local bullet_impacts, bullet_impacts_time = ref("VISUALS", "Effects", "Bullet impacts") df(bullet_impacts) vis(bullet_impacts_time)
end

local function disable_visuals_coloredmodels()
	local player, player_color = ref("VISUALS", "Colored models", "Player") df(player) vis(player_color)
	local player_behind_wall, player_behind_wall_color = ref("VISUALS", "Colored models", "Player behind wall") df(player_behind_wall) vis(player_behind_wall_color)
	local reflectivity_slider, reflectivity_color = ref("VISUALS", "Colored models", "Reflectivity") vis(reflectivity_slider) vis(reflectivity_color)
	local shine_slider = ref("VISUALS", "Colored models", "Shine") vis(shine_slider)
	local rim_slider = ref("VISUALS", "Colored models", "Rim") vis(rim_slider)
	local show_teammates, show_teammates_color = ref("VISUALS", "Colored models", "Show teammates") df(show_teammates) vis(show_teammates_color)
	local disable_model_occlusion = ref("VISUALS", "Colored models", "Disable model occlusion") df(disable_model_occlusion)
	local shadow, shadow_color = ref("VISUALS", "Colored models", "Shadow") df(shadow) vis(shadow_color)
end

local misc = {
	tab 		= "misc", 
	misc 		= "miscellaneous", 
	settings 	= "settings",
	other 		= "other",
	lua			= "lua"
}

local function disable_misc_miscellaneous()
	local of = ref(misc.tab, misc.misc, "override fov") set(of, 90) vis(of)
	local bh = ref(misc.tab, misc.misc, "bunny hop") df(bh)
	local as = ref(misc.tab, misc.misc, "air strafe") df(as)
	local asd = ref(misc.tab, misc.misc, "air strafe direction") vis(asd)
	local ass = ref(misc.tab, misc.misc, "air strafe smoothing") set(ass, 0) vis(ass)
	local ad = ref(misc.tab, misc.misc, "air duck") set(ad, "off") vis(ad)
	local kb = ref(misc.tab, misc.misc, "knifebot") df(kb)
	local zb = ref(misc.tab, misc.misc, "zeusbot") df(zb)
	local bb, bbh = ref(misc.tab, misc.misc, "blockbot") df(bb) vis(bbh)
	local aw, aws = ref(misc.tab, misc.misc, "automatic weapons") df(aw) vis(aws)
	local jae, jaeh = ref(misc.tab, misc.misc, "jump at edge") df(jae) vis(jaeh)
	local cts = ref(misc.tab, misc.misc, "clan tag spammer") df(cts)
	local lwp = ref(misc.tab, misc.misc, "log weapon purchases") df(lwp)
	local ldd = ref(misc.tab, misc.misc, "log damage dealt") df(ldd)
	local agr, agrh = ref(misc.tab, misc.misc, "automatic grenade release") df(agr) vis(agrh)
	local ps, psh, pss = ref(misc.tab, misc.misc, "ping spike") df(ps) vis(psh) vis(pss)
	local fw = ref(misc.tab, misc.misc, "fast walk") df(fw)
	local fl = ref(misc.tab, misc.misc, "free look") vis(fl)
	local spn = ref(misc.tab, misc.misc, "steal player name") vis(spn)
end

local function disable_misc_settings()
	local mk = ref(misc.tab, misc.settings, "menu key") vis(mk)
	local mc = ref(misc.tab, misc.settings, "menu color") vis(mc)
	local au = ref(misc.tab, misc.settings, "anti-untrusted") set(au, true) vis(au)
	local hfo = ref(misc.tab, misc.settings, "hide from obs") df(hfo)
	local lfw = ref(misc.tab, misc.settings, "low fps warning") df(lfw)
	local lml = ref(misc.tab, misc.settings, "lock menu layout") df(lml)
end

local function disable_misc_other()
	local lc = ref(misc.tab, misc.other, "load config") vis(lc)
	local sc = ref(misc.tab, misc.other, "save config") vis(sc)
	local rc = ref(misc.tab, misc.other, "reset config") vis(rc)
	local ifc = ref(misc.tab, misc.other, "import from clipboard") vis(ifc)
	local etc = ref(misc.tab, misc.other, "export to clipboard") vis(etc)
	local rml = ref(misc.tab, misc.other, "reset menu layout") vis(rml)
	local u = ref(misc.tab, misc.other, "unload") vis(u)
end

local function disable_misc_lua()
	local ls = ref(misc.tab, misc.lua, "load script") vis(ls) 
	local us = ref(misc.tab, misc.lua, "unload script") vis(us)
	local b = ref(misc.tab, misc.lua, "back") vis(b)
	local s,ss = ref(misc.tab, misc.lua, "reload active scripts") vis(ss)
	local los = ref(misc.tab, misc.lua, "load on startup") vis(los)
end

local function asdf()
	disable_rage_aimbot()
	disable_rage_other()

	disable_antiaim_antiaim()
	disable_antiaim_fakelag()

	disable_legitbot_aimbot()
	disable_legitbot_triggerbot()

	disable_visuals_playeresp()
	disable_visuals_otheresp()
	disable_visuals_effects()
	disable_visuals_coloredmodels()

	disable_misc_miscellaneous()
	disable_misc_settings()
	disable_misc_other()
	disable_misc_lua()
end
asdf()
client.set_event_callback("paint", function()
	asdf()
end)
