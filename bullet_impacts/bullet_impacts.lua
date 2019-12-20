local ffi = require("ffi")

local bullet_impacts = ui.new_checkbox("visuals", "effects", "Bullet impacts")
local server_color = ui.new_color_picker("visuals", "effects", "Server impacts", 0, 0, 255, 127)
local bullet_impacts_duration = ui.new_slider("visuals", "effects", "\nbullet_impacts_duration", 1, 20, 4, true, "s")
local client_color = ui.new_color_picker("visuals", "effects", "Client impacts", 255, 0, 0, 127)

ui.set_callback(bullet_impacts, function(s)
    local state = ui.get(s)
    ui.set_visible(server_color, state)
    ui.set_visible(bullet_impacts_duration, state)
    ui.set_visible(client_color, state)
end)


ffi.cdef[[
    struct vec3_t{
		float x;
		float y;
		float z;	
    };
    typedef void(__thiscall* add_box_overlay_t)(void*, const struct vec3_t&, const struct vec3_t&, const struct vec3_t&, struct vec3_t const&, int, int, int, int, float);
]]

local debug_overlay = ffi.cast(ffi.typeof("void***"), client.create_interface("engine.dll", "VDebugOverlay004"))
local add_box_overlay = ffi.cast("add_box_overlay_t", debug_overlay[0][1])

local sin, cos, rad = math.sin, math.cos, math.rad
function angle_forward( angle ) -- angle -> direction vector (forward)
    local sin_pitch = sin( rad( angle[1] ) )
    local cos_pitch = cos( rad( angle[1] ) )
    local sin_yaw   = sin( rad( angle[2] ) )
    local cos_yaw   = cos( rad( angle[2] ) )

    return {        
        cos_pitch * cos_yaw,
        cos_pitch * sin_yaw,
        -sin_pitch
    }
end

local function draw_impact(x,y,z, color)
    local r,g,b,a = ui.get(color)
    local dur = ui.get(bullet_impacts_duration)

    local position = ffi.new("struct vec3_t")
    position.x = x position.y = y position.z = z
    local mins = ffi.new("struct vec3_t")
    mins.x = -2 mins.y = -2 mins.z = -2
    local maxs = ffi.new("struct vec3_t")
    maxs.x = 2 maxs.y = 2 maxs.z = 2
    local ori = ffi.new("struct vec3_t")
    ori.x = 0 ori.y = 0 ori.z = 0

    add_box_overlay(debug_overlay, position, mins, maxs, ori, r, g, b, a, dur)
end

client.set_event_callback("aim_fire", function(e)
    if ui.get(bullet_impacts) then 
        draw_impact(e.x,e.y,e.z, client_color)
    end
end)

client.set_event_callback("bullet_impact", function(e)
    if ui.get(bullet_impacts) then 
        draw_impact(e.x,e.y,e.z, server_color)
    end
end)

client.set_event_callback("weapon_fire", function(e)
    local entindex = client.userid_to_entindex(e.userid)
    local me = entity.get_local_player()

    if entindex == me and client.key_state(0x01) and ui.get(bullet_impacts) and not e.weapon:find("knife") then 
        local pitch, yaw = client.camera_angles()
        local punch = {entity.get_prop(me, "m_aimPunchAngle")}
        pitch = pitch + (punch[1] * cvar.weapon_recoil_scale:get_float())
        yaw = yaw + (punch[2] * cvar.weapon_recoil_scale:get_float())

        local fwd = angle_forward( { pitch, yaw, 0 } )
        local start_pos = { client.eye_position() }
        local fraction = client.trace_line(me, 
            start_pos[1],
            start_pos[2],
            start_pos[3],
            start_pos[1] + (fwd[1] * 8192),
            start_pos[2] + (fwd[2] * 8192),
            start_pos[3] + (fwd[3] * 8192))

        if fraction < 1 then 
            local end_pos = {
                start_pos[1] + (fwd[1] * (8192 * fraction)),
                start_pos[2] + (fwd[2] * (8192 * fraction)),
                start_pos[3] + (fwd[3] * (8192 * fraction)),
            }
            draw_impact(end_pos[1],end_pos[2],end_pos[3], client_color)
        end
    end
end)
