local drone_aimbot = ui.new_checkbox("lua", "b", "Drone aimbot")
local aimbot_hotkey = ui.new_hotkey("lua", "b", "Drone aimbot", true)
local aimbot_silent_aim = ui.new_checkbox("lua", "b", "Silent aim")

local eye_position, camera_angles, visible, trace_line = client.eye_position, client.camera_angles, client.visible, client.trace_line
local text, world_to_screen = renderer.text, renderer.world_to_screen
local get_prop, get_all, get_local_player = entity.get_prop, entity.get_all, entity.get_local_player
local deg, atan2, sqrt = math.deg, math.atan2, math.sqrt
local get = ui.get

local function vector_angles(x1, y1, z1, x2, y2, z2)
    --https://github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/mathlib/mathlib_base.cpp#L535-L563
    local origin_x, origin_y, origin_z
    local target_x, target_y, target_z
    if x2 == nil then
        target_x, target_y, target_z = x1, y1, z1
        origin_x, origin_y, origin_z = eye_position()
        if origin_x == nil then
            return
        end
    else
        origin_x, origin_y, origin_z = x1, y1, z1
        target_x, target_y, target_z = x2, y2, z2
    end

    --calculate delta of vectors
    local delta_x, delta_y, delta_z = target_x-origin_x, target_y-origin_y, target_z-origin_z

    if delta_x == 0 and delta_y == 0 then
        return (delta_z > 0 and 270 or 90), 0
    else
        --calculate yaw
        local yaw = deg(atan2(delta_y, delta_x))

        --calculate pitch
        local hyp = sqrt(delta_x*delta_x + delta_y*delta_y)
        local pitch = deg(atan2(-delta_z, hyp))

        return pitch, yaw
    end
end

local function get_dist(a_x, a_y, a_z, b_x, b_y, b_z)
    return math.sqrt(math.pow(a_x - b_x, 2) + math.pow(a_y - b_y, 2) + math.pow(a_z - b_z, 2))
end

local function get_closest_drone()
	local target = nil
	local min_distance = 8192
	local me = get_local_player()
	local mx,my,mz = get_prop(me, "m_vecAbsOrigin")
    for _, ent in pairs(get_all("CDrone")) do
        local x,y,z = get_prop(ent, "m_vecOrigin")
        local distance = get_dist(mx,my,mz,x,y,z)
        local frac = trace_line(me, mx,my,mz,x,y,z)
		if distance < min_distance and frac < 1 and frac > 0.9 then
			min_distance = distance
			target =ent
		end
    end
	return target
end

local cur_target = nil
client.set_event_callback("setup_command", function(cmd)
    if get(drone_aimbot) then 
        local target = get_closest_drone()
        if target then 
            local x,y,z = get_prop(target, "m_vecOrigin")
            local pitch, yaw = vector_angles(x,y,z)
            if get(aimbot_hotkey) then 
                cur_target = target
                if get(aimbot_silent_aim) then 
                    cmd.pitch = pitch
                    cmd.yaw = yaw
                else
                    camera_angles(pitch, yaw)
                end
            end
        end
    end
end)
client.set_event_callback("paint", function(ctx)
    if get(drone_aimbot) then 
        for _, ent in pairs(get_all("CDrone")) do
            local x,y,z = get_prop(ent, "m_vecOrigin")
            local wx, wy = world_to_screen(x, y, z)
            if get(aimbot_hotkey) then 
                if wx then 
                    local r,g,b = 255,255,255
                    if ent == cur_target then 
                        r,g,b = 255,0,0
                    end
                    text(wx, wy, r, g, b, 255, "-", 999, "DRONE")
                end
            end
        end
    end
end)
