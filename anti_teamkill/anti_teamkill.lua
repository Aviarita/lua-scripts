local GetUi = ui.get
local NewCheckbox = ui.new_checkbox
local NewRef = ui.reference
local SetVisible = ui.set_visible
local SetCallback = ui.set_callback

local sqrt, sin, cos   = math.sqrt, math.sin, math.cos

local Log = client.log
local AddEvent = client.set_event_callback
local GetLocalPlayer = entity.get_local_player
local GetProp = entity.get_prop
local SetProp = entity.set_prop

local ui = {
	enabled = NewCheckbox("misc","miscellaneous", "Anti-teamkill"),
	ignore_while_spraying = NewCheckbox("misc", "miscellaneous", "Ignore while spraying"),
	ragebot = NewRef("rage", "aimbot", "enabled"),
}

-- credits to eso --
local pi = 3.14159265358979323846
local deg2rad = pi / 180.0
local rad2deg = 180.0 / pi

local function vec3_normalize(x, y, z)
	local len = sqrt(x * x + y * y + z * z)
	if len == 0 then
		return 0, 0, 0
	end
	local r = 1 / len
	return x*r, y*r, z*r
end

local function vec3_dot(ax, ay, az, bx, by, bz)
	return ax*bx + ay*by + az*bz
end

local function angle_to_vec(pitch, yaw)
	local p, y = deg2rad*pitch, deg2rad*yaw
	local sp, cp, sy, cy = sin(p), cos(p), sin(y), cos(y)
	return cp*cy, cp*sy, -sp
end

local function aiming_at_me(ent, lx, ly, lz)
	local pitch, yaw, roll = GetProp(ent, "m_angEyeAngles")
	if pitch == nil then return end

	local ex, ey, ez = angle_to_vec(pitch, yaw)
	local px, py, pz = GetProp(ent, "m_vecOrigin")
	if px == nil then return end

	local dx, dy, dz = vec3_normalize(lx-px, ly-py, lz-pz)
	return vec3_dot(dx, dy, dz, ex, ey, ez) > 0.98480775301
end

-- credits end --

SetVisible(ui.ignore_while_spraying, false)
SetCallback(ui.enabled, function()
	SetVisible(ui.ignore_while_spraying, GetUi(ui.enabled))
end)

AddEvent("run_command", function()

	if not GetUi(ui.enabled) then 
		client.exec("bind mouse1 +attack")
		return 
	end

	local players = entity.get_players(false)
	
	for i=1, #players do

		local player = players[i]

		if GetProp(player, "m_iTeamNum") ~= GetProp(GetLocalPlayer(), "m_iTeamNum") then return end

		if GetUi(ui.ragebot) then return end
		
		local shots_fired = GetProp(GetLocalPlayer(), "m_iShotsFired")
	
		if shots_fired > 2 and GetUi(ui.ignore_while_spraying) then return end

		local originx, originy, originz = GetProp(player, "m_vecOrigin")
		if originx == nil then return end

		if aiming_at_me(GetLocalPlayer(), originx, originy, originz) then
			client.exec("unbind mouse1; -attack")
		else
			client.exec("bind mouse1 +attack")
		end
	end

end)
