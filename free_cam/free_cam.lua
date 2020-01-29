------------------------------------ FFI STUFF ------------------------------------
local ffi = require("ffi")
local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(ffi.typeof("void***"), rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast(ffi.typeof("void*(__thiscall*)(void*, int)"), ientitylist[0][3]) or error("get_client_entity is nil", 2)

local sig = client.find_signature("client_panorama.dll", "\x55\x8B\xEC\x83\xE4\xF8\x51\x53\x56\x57\x8B\xF1\xE8")
local a_set_abs_origin = ffi.cast(ffi.typeof("void( __thiscall*)(void*, const void&)"), sig)

local vec3_struct = ffi.typeof("struct { float x, y, z; }")

local function set_abs_origin(entity, x, y, z)
    local pos = ffi.new(vec3_struct, {x, y, z})
    a_set_abs_origin(get_client_entity(ientitylist, entity), pos)
end

------------------------------------ MENU STUFF ------------------------------------

local free_cam_speed = ui.new_slider("misc", "movement", "Free cam", 0, 100, 0, 50, "%")
local free_cam_hotkey = ui.new_hotkey("misc", "movement", "Free cam", true)
local update_angles = ui.new_checkbox("misc", "movement", "Update angles")

------------------------------------ LOCALIZING STUFF ------------------------------------

local key_state = client.key_state
local get_local_player, get_prop, hitbox_position = entity.get_local_player, entity.get_prop, entity.hitbox_position
local camera_angles, eye_position, trace_line = client.camera_angles, client.eye_position, client.trace_line
local world_to_screen, text, line = renderer.world_to_screen, renderer.text, renderer.line
local cos, sin, rad, atan2, deg, sqrt = math.cos, math.sin, math.rad, math.atan2, math.deg, math.sqrt
local get = ui.get

local VK_SHIFT, VK_CTRL, VK_SPACE, VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN = 0x10, 0x11, 0x20, 0x41, 0x57, 0x44, 0x53

------------------------------------ FUNCTIONS ------------------------------------


local function rotate(point, center, yaw)
    local rad = rad(yaw) 
    local sin = sin(rad)
    local cos = cos(rad)

    point[1] = point[1] - center[1]
    point[2] = point[2] - center[2]

    local nx = point[1] * cos - point[2] * sin
    local ny = point[1] * sin + point[2] * cos

    return nx + center[1], ny + center[2]
end

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

local function valid(self, indices) 
    local v = {}
    for i=1, #indices do 
        if self[indices[i]] ~= nil then 
            table.insert(v, true)
        end
    end
    return #v == #indices
end

local w2s_table = {}
local hb_pos = {}

local x, y, z = 0,0,0
local sx, sy, sz = 0,0,0
local cachedYaw = 0

local function fwd_to_angle(me)
    local pitch, yaw = camera_angles()

    local fwd = angle_forward( { pitch, yaw, 0 } )
    local start_pos = { eye_position() }
    local fraction = trace_line(me, 
        start_pos[1],
        start_pos[2],
        start_pos[3],
        start_pos[1] + (fwd[1] * 8192),
        start_pos[2] + (fwd[2] * 8192),
        start_pos[3] + (fwd[3] * 8192))

    local end_pos = {
        start_pos[1] + (fwd[1] * (8192 * fraction)),
        start_pos[2] + (fwd[2] * (8192 * fraction)),
        start_pos[3] + (fwd[3] * (8192 * fraction)),
    }

    local viewOffset = get_prop(me, "m_vecViewOffset[2]")
    end_pos[3] = end_pos[3] - viewOffset

    local pitch, yaw = vector_angles(sx, sy, sz, end_pos[1], end_pos[2], end_pos[3])
    return pitch, yaw, end_pos
end

client.set_event_callback("paint", function(ctx)
    local me = get_local_player()
    if not ui.get(free_cam_hotkey) then 
        for i = 0, 18 do
            local ax, ay, az = hitbox_position(me, i)
            hb_pos[i] = {ax,ay,az}
        end
    else
        local pitch, yaw, end_pos = fwd_to_angle(me)

        for i=0, #hb_pos do 
            local x,y,z = unpack(hb_pos[i])

            if get(update_angles) then 
                x, y = rotate({ x, y }, { sx, sy }, yaw - cachedYaw)
            end

            local x_w2s, y_w2s = world_to_screen(x, y, z)
            if x_w2s ~= nil then
                w2s_table[i] = { x_w2s, y_w2s }
            end
        end

        local w2s = {world_to_screen(sx,sy,sz)}

        if valid(w2s, {1, 2}) then 
            if valid(w2s_table, {0}) then
                text(w2s_table[0][1], w2s_table[0][2]-5, 255, 255, 255, 255, "cb", 0, "You")
            end
            
            if valid(w2s_table, {0, 1, 6}) then 
                --head and neck
                line(w2s_table[0][1], w2s_table[0][2], w2s_table[1][1], w2s_table[1][2], 255, 255, 255, 255)
                line(w2s_table[1][1], w2s_table[1][2], w2s_table[6][1], w2s_table[6][2], 255, 255, 255, 255)
            end
            if valid(w2s_table, {6, 17, 15, 4, 2}) then 
                --arms
                line(w2s_table[6][1], w2s_table[6][2], w2s_table[17][1], w2s_table[17][2], 255, 255, 255, 255)
                line(w2s_table[6][1], w2s_table[6][2], w2s_table[15][1], w2s_table[15][2], 255, 255, 255, 255)
                line(w2s_table[6][1], w2s_table[6][2], w2s_table[4][1], w2s_table[4][2], 255, 255, 255, 255)
                line(w2s_table[4][1], w2s_table[4][2], w2s_table[2][1], w2s_table[2][2], 255, 255, 255, 255)
            end
            if valid(w2s_table, {2, 7, 8})then 
                --waist
                line(w2s_table[2][1], w2s_table[2][2], w2s_table[7][1], w2s_table[7][2], 255, 255, 255, 255)
                line(w2s_table[2][1], w2s_table[2][2], w2s_table[8][1], w2s_table[8][2], 255, 255, 255, 255)
            end
            if valid(w2s_table, {7, 9, 11}) then 
                --left leg
                line(w2s_table[7][1], w2s_table[7][2], w2s_table[9][1], w2s_table[9][2], 255, 255, 255, 255)
                line(w2s_table[9][1], w2s_table[9][2], w2s_table[11][1], w2s_table[11][2], 255, 255, 255, 255)
            end
            if valid(w2s_table, {8, 10, 12}) then 
                --right leg
                line(w2s_table[8][1], w2s_table[8][2], w2s_table[10][1], w2s_table[10][2], 255, 255, 255, 255)
                line(w2s_table[10][1], w2s_table[10][2], w2s_table[12][1], w2s_table[12][2], 255, 255, 255, 255)
            end
            if valid(w2s_table, {17, 18, 14}) then 
                --left arm
                line(w2s_table[17][1], w2s_table[17][2], w2s_table[18][1], w2s_table[18][2], 255, 255, 255, 255)
                line(w2s_table[18][1], w2s_table[18][2], w2s_table[14][1], w2s_table[14][2], 255, 255, 255, 255)
            end
            if valid(w2s_table, {15, 16, 13}) then 
                --right arm
                line(w2s_table[15][1], w2s_table[15][2], w2s_table[16][1], w2s_table[16][2], 255, 255, 255, 255)
                line(w2s_table[16][1], w2s_table[16][2], w2s_table[13][1], w2s_table[13][2], 255, 255, 255, 255)
            end
        end
    end
end)

local wasDucking = false

client.set_event_callback("predict_command", function()
    local me = get_local_player()

    if not ui.get(free_cam_hotkey) then 
        x, y, z = get_prop(me, "m_vecOrigin")
        sx, sy, sz = get_prop(me, "m_vecOrigin")
        cachedYaw = select(2, camera_angles())
    else
        local pitch, yaw = camera_angles()

        local nx = cos(rad(yaw)) * cos(rad(pitch))
        local ny = sin(rad(yaw)) * cos(rad(pitch))

        local lrnx = cos(rad(yaw)) 
        local lrny = sin(rad(yaw)) 

        local nz = sin(rad(pitch))

        local speed = get(free_cam_speed) * 0.15

        if key_state(VK_SHIFT) then 
            speed = speed + (speed * 0.75)
        end

        nx = nx * speed
        ny = ny * speed
        lrny = lrny * speed
        lrnx = lrnx * speed
        nz = nz * speed

        x = x  - 0.0001 y = y  - 0.0001 
        x = x + 0.0002 y = y + 0.0002

        if wasDucking and not key_state(VK_CTRL) then 
            wasDucking = false
        end

        if key_state(VK_UP) then 
            x = x + nx
            y = y + ny
            z = z - nz
        end
        if key_state(VK_DOWN) then 
            x = x - nx
            y = y - ny
            z = z + nz  
        end
        if key_state(VK_RIGHT) then 
            x = x + lrny
            y = y - lrnx
        end
        if key_state(VK_LEFT) then 
            x = x - lrny
            y = y + lrnx
        end
        if key_state(VK_SPACE) then 
            z = z + speed
        end
        if key_state(VK_CTRL) and not wasDucking then 
            z = z - speed              
        end

        set_abs_origin(me, x, y, z)
    end
end)

local o_pitch = 0
local o_yaw = 0
local revertAngles = false
client.set_event_callback("setup_command", function(cmd)
    if not get(free_cam_hotkey) then 
        if revertAngles then 
            camera_angles(o_pitch, o_yaw)
            revertAngles = false
        end
        o_pitch = cmd.pitch
        o_yaw = cmd.yaw
        wasDucking = cmd.in_duck
    else  
        local me = get_local_player()

        if get(update_angles) then 
            local pitch, yaw = fwd_to_angle(me)
            cmd.pitch = pitch
            cmd.yaw = yaw
            o_pitch = pitch
            o_yaw = yaw
            revertAngles = true
        else 
            cmd.pitch = o_pitch
            cmd.yaw = o_yaw
            revertAngles = true
        end

        cmd.forwardmove = 0
        cmd.sidemove = 0
        cmd.in_jump = 0
        cmd.in_duck = wasDucking
    end
end)

ui.set_callback(update_angles, function(self)
    if get(free_cam_hotkey) and not get(self) then 
        o_pitch, o_yaw = camera_angles()
        cachedYaw = o_yaw
    end
end)
