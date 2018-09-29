local GetUi = ui.get
local SetUi = ui.set
local SetVisible = ui.set_visible

local Log = client.log
local cmd = client.exec
local AddEvent = client.set_event_callback

local hitchance_ref = ui.reference("RAGE", "Aimbot", "Minimum hit chance")
local increase_hit_chance_on_miss = ui.new_checkbox("RAGE", "Other", "Increase hit chance on miss")
local max_missed_shots = ui.new_slider("RAGE", "Other", "Max misses before increasing", 1, 5, 0)
local increase_hit_chance = ui.new_slider("RAGE", "Other", "Increase hit chance by", 1, 15, 0, true, "%")
local old_hitchance = ui.new_slider("RAGE", "Other", "Old hit chance", 0, 100, 0, true, "%")

SetUi(old_hitchance, GetUi(hitchance_ref))

local missed_shots = 0

local function clamp(min, max, current)
	if current > max then current = max 
	elseif current < min then current = min end
	return math.floor(current)
end

local function on_aim_miss(event)
	if not GetUi(increase_hit_chance_on_miss) then return end
	local current_hitchance = GetUi(hitchance_ref)
	missed_shots = missed_shots + 1
	if missed_shots >= GetUi(max_missed_shots) and GetUi(hitchance_ref) ~= 100 then
		Log("Set hit chance to " .. clamp(0, 100, current_hitchance + GetUi(increase_hit_chance)))
		SetUi(hitchance_ref, clamp(0, 100, current_hitchance + GetUi(increase_hit_chance)))
	end
end

local function on_aim_hit(event)
	if not GetUi(increase_hit_chance_on_miss) then return end
	missed_shots = 0
	if GetUi(hitchance_ref) ~= GetUi(old_hitchance) then
		Log("Set hit chance to " .. GetUi(old_hitchance))
		SetUi(hitchance_ref, GetUi(old_hitchance))
	end
end

local function change_visibility(event)
	SetVisible(max_missed_shots, GetUi(increase_hit_chance_on_miss))
	SetVisible(increase_hit_chance, GetUi(increase_hit_chance_on_miss))
	SetVisible(old_hitchance, GetUi(increase_hit_chance_on_miss))
end

AddEvent("run_command", change_visibility)
AddEvent("aim_miss", on_aim_miss)
AddEvent("aim_hit", on_aim_hit)
