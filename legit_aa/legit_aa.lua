local yaw, yaw_slider = ui.reference("aa", "anti-aimbot angles", "yaw")
local body_yaw, body_yaw_slider = ui.reference("aa", "anti-aimbot angles", "body yaw")
local lby_target = ui.reference("aa", "anti-aimbot angles", "lower body yaw target")
local flag_limit = ui.reference("aa", "fake lag", "Limit")
local enabled = ui.new_checkbox("aa", "anti-aimbot angles", "Legit AA")
local swap_sides = ui.new_hotkey("aa", "anti-aimbot angles", "Legit AA", true)
local disable_when_moving = ui.new_slider("aa", "anti-aimbot angles", "Velocity threshold", 1, 250, 10)

local set, get = ui.set, ui.get
local floor, min, sqrt = math.floor, math.min, math.sqrt
local get_prop, get_lp = entity.get_prop, entity.get_local_player
local indicator = renderer.indicator

ui.set_callback(enabled, function(self)
    if get(self) then 
        set(yaw, "180")
        set(yaw_slider, -180)
        set(body_yaw, "Static")
        set(body_yaw_slider, -180)
        set(lby_target, "Opposite")
        set(flag_limit, 4)
    else
        set(yaw, "Off")
        set(yaw_slider, 0)
        set(body_yaw, "Off")
        set(body_yaw_slider, 0)
        set(lby_target, "Off")
    end
end)
local function length3d(self)
    return floor(min(10000, sqrt( 
		( self[1] * self[1] ) +
		( self[2] * self[2] ) +
		( self[3] * self[3] ))+ 0.5)
	)
end
client.set_event_callback("run_command", function(e)
    if get(enabled) == false then return end
    if get(swap_sides) then 
        set(body_yaw_slider, 180)
    else
        set(body_yaw_slider, -180)
    end

    local me = get_lp()
    local my_vel = length3d({get_prop(me, "m_vecVelocity")})
    if my_vel > get(disable_when_moving) then 
        set(yaw, "Off")
        set(body_yaw, "Off")
        set(lby_target, "Off")
        set(flag_limit, 1)
    else
        set(yaw, "180")
        set(body_yaw, "Static")
        set(lby_target, "Opposite")
        set(flag_limit, 4)
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
