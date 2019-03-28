local get = ui.get
local set = ui.set
local ref, cb, sld = ui.reference, ui.new_checkbox, ui.new_slider
local setvis = ui.set_visible
local cllbck = ui.set_callback

local AddEvent = client.set_event_callback

local hitchance_ref = ref("rage", "aimbot", "minimum hit chance")
local increase_hit_chance_on_miss = cb("RAGE", "Other", "Increase hit chance on miss")
local max_missed_shots = sld("RAGE", "Other", "Max misses before increasing", 1, 5, 1)
local increase_hit_chance = sld("RAGE", "Other", "Increase hit chance by", 1, 15, 1, true, "%")
local logs = cb("rage", "other", "Enable logging")

local missed_shots, old_hitchance, new_hitchance = 0, get(hitchance_ref), 1

local function clamp(min, max, current)
	if current > max then current = max 
	elseif current < min then current = min end
	return math.floor(current)
end

local function on_aim_miss(event)
	if not get(increase_hit_chance_on_miss) then return end
	new_hitchance = get(hitchance_ref) + get(increase_hit_chance)
	missed_shots = missed_shots + 1
	if missed_shots >= get(max_missed_shots) and get(hitchance_ref) ~= 100 then
		if get(logs) then
			print("Set hit chance to " .. clamp(0, 100, new_hitchance))
		end
		set(hitchance_ref, clamp(0, 100, new_hitchance))
	end
end

local function on_aim_hit(event)
	if not get(increase_hit_chance_on_miss) then return end
	missed_shots = 0
	if get(hitchance_ref) ~= old_hitchance then
		if get(logs) then
			print("Set hit chance to " .. old_hitchance)
		end
		set(hitchance_ref, old_hitchance)
	end
end

AddEvent("aim_miss", on_aim_miss)
AddEvent("aim_hit", on_aim_hit)

setvis(max_missed_shots, false)
setvis(increase_hit_chance, false)
setvis(logs, false)
cllbck(increase_hit_chance_on_miss, function()
	setvis(max_missed_shots, get(increase_hit_chance_on_miss))
	setvis(increase_hit_chance, get(increase_hit_chance_on_miss))
	setvis(logs, get(increase_hit_chance_on_miss))
end)

client.set_event_callback("paint", function(ctx) 
	if get(hitchance_ref) ~= old_hitchance and get(hitchance_ref) ~= clamp(0, 100, new_hitchance) then 
		old_hitchance = get(hitchance_ref)
	end
end)
