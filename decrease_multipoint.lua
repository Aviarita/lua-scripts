local GetUi = ui.get
local SetUi = ui.set
local SetVisible = ui.set_visible

local Log = client.log
local cmd = client.exec
local AddEvent = client.set_event_callback

local pointscale_ref = ui.reference("RAGE", "Aimbot", "Multi-point scale")
local decrease_pointscale_on_miss = ui.new_checkbox("RAGE", "Other", "Decrease multi-point on miss")
local max_missed_shots = ui.new_slider("RAGE", "Other", "Max misses before decreasing", 1, 5, 0)
local increase_hit_chance = ui.new_slider("RAGE", "Other", "Decrease multi-point by", 1, 15, 0, true, "%")
local old_multi_point = ui.new_slider("RAGE", "Other", "Old multi-point scale", 0, 100, 0, true, "%")

SetUi(old_multi_point, GetUi(pointscale_ref))

local missed_shots = 0

local function clamp(min, max, current)
	if current > max then current = max 
	elseif current < min then current = min end
	return math.floor(current)
end

local function on_aim_miss(event)
	if not GetUi(decrease_pointscale_on_miss) then return end
	local current_hitchance = GetUi(pointscale_ref)
	missed_shots = missed_shots + 1
	if missed_shots >= GetUi(max_missed_shots) and GetUi(pointscale_ref) ~= 0 then
		Log("Set multi-point to " .. clamp(24, 100, current_hitchance - GetUi(increase_hit_chance)))
		SetUi(pointscale_ref, clamp(24, 100, current_hitchance - GetUi(increase_hit_chance)))
	end
end

local function on_aim_hit(event)
	if not GetUi(decrease_pointscale_on_miss) then return end
	missed_shots = 0
	if GetUi(pointscale_ref) ~= GetUi(old_multi_point) then
		Log("Set multi-point to " .. GetUi(old_multi_point))
		SetUi(pointscale_ref, GetUi(old_multi_point))
	end
end

local function change_visibility(event)
	SetVisible(max_missed_shots, GetUi(decrease_pointscale_on_miss))
	SetVisible(increase_hit_chance, GetUi(decrease_pointscale_on_miss))
	SetVisible(old_multi_point, GetUi(decrease_pointscale_on_miss))
end

AddEvent("run_command", change_visibility)
AddEvent("aim_miss", on_aim_miss)
AddEvent("aim_hit", on_aim_hit)
