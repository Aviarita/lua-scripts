local enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Legit AA")
local swap_sides = ui.new_hotkey("aa", "anti-aimbot angles", "Legit AA", true)
local disable_when_moving = ui.new_slider("aa", "anti-aimbot angles", "Velocity threshold", 1, 250, 10)
local display_angles = ui.new_checkbox("aa", "anti-aimbot angles", "Display angles(Ragebot)")

local aa_master = ui.reference("aa", "anti-aimbot angles", "enabled")
local yaw, yaw_slider = ui.reference("aa", "anti-aimbot angles", "yaw")
local body_yaw, body_yaw_slider = ui.reference("aa", "anti-aimbot angles", "body yaw")
local lby_target = ui.reference("aa", "anti-aimbot angles", "lower body yaw target")
local flag_limit = ui.reference("aa", "fake lag", "Limit")

local ragebot = ui.reference("rage", "aimbot", "enabled")
local target_hitbox = ui.reference("rage", "aimbot", "target hitbox")
local minimum_hitchance = ui.reference("rage", "aimbot", "minimum hit chance")
local minimum_minimum_damage = ui.reference("rage", "aimbot", "minimum damage")
local fov = ui.reference("rage", "aimbot", "maximum fov")
local fake_shadow = ui.reference("visuals", "colored models", "local player fake")

local set, get, vis = ui.set, ui.get, ui.set_visible
local floor, min, sqrt = math.floor, math.min, math.sqrt
local get_prop, get_lp = entity.get_prop, entity.get_local_player
local indicator = renderer.indicator

local function length3d(self)
    return floor(min(10000, sqrt( 
		( self[1] * self[1] ) +
		( self[2] * self[2] ) +
		( self[3] * self[3] ))+ 0.5)
	)
end

vis(disable_when_moving, false)
vis(display_angles, false)

ui.set_callback(enabled, function(self)
    if get(self) then 
        set(aa_master, true)
        set(yaw, "180")
        set(yaw_slider, -180)
        set(body_yaw, "Static")
        set(body_yaw_slider, -180)
        set(lby_target, "Opposite")
        set(flag_limit, 4)
    else
        set(aa_master, false)
        set(yaw, "Off")
        set(yaw_slider, 0)
        set(body_yaw, "Off")
        set(body_yaw_slider, 0)
        set(lby_target, "Off")
    end
    vis(disable_when_moving, get(self))
    vis(display_angles, get(self))
end)

ui.set_callback(display_angles, function(self)
    if get(enabled) then 
        local state = get(self)
        set(ragebot, state)
        set(fake_shadow, state)
         if state then 
            set(target_hitbox, "feet")
            set(minimum_hitchance, 100)
            set(minimum_minimum_damage, 126)
            set(fov, 1)
        end
    end
end)

local disabled_aa = false
client.set_event_callback("setup_command", function(cmd)
    if get(enabled) == false then return end
    local me = get_lp()
    local my_vel = length3d({get_prop(me, "m_vecVelocity")})
    if my_vel > get(disable_when_moving) or (cmd.in_use or cmd.in_attack2 or cmd.in_attack) == 1 then 
        set(aa_master, false)
        disabled_aa = true
    else 
        if disabled_aa then 
            set(aa_master, true)
            disabled_aa = false
        end
    end

    if disabled_aa == false then 
        if get(swap_sides) then 
            set(body_yaw_slider, 180)
        else
            set(body_yaw_slider, -180)
        end
    end
end)

client.set_event_callback("paint", function()
    if get(enabled) == false then return end
    if get(body_yaw_slider) == -180 then 
        indicator(255, 255,255, 255, "RIGHT")
    elseif get(body_yaw_slider) == 180 then 
        indicator(255, 255,255, 255, "LEFT")
    end
end)

client.set_event_callback("shutdown", function()
    if get(enabled) then 
        set(aa_master, false)
        set(yaw, "Off")
        set(yaw_slider, 0)
        set(body_yaw, "Off")
        set(body_yaw_slider, 0)
        set(lby_target, "Off")
        set(ragebot, false)
    end
end)
