local GetUi = ui.get
local SetUi = ui.set
local SetVisible = ui.set_visible
local GetLocalPlayer = entity.get_local_player

local screenx, screeny = client.screen_size()
local left = screenx - screenx
local right = screenx
local top = screeny - screeny
local bottom = screeny

local GetAll = entity.get_all
local GetProp = entity.get_prop

local Log = client.log

local table_insert, table_remove = table.insert, table.remove
local globals_realtime, globals_absoluteframetime, globals_tickinterval = globals.realtime, globals.absoluteframetime, globals.tickinterval
local min, abs, sqrt, floor = math.min, math.abs, math.sqrt, math.floor

-- client.draw_text(paint_ctx, x, y, r, g, b, a, flags, max_width, ...) --
local DrawText = client.draw_text
local DrawRect = client.draw_rectangle
local DrawGradient = client.draw_gradient

local Infobox = ui.new_checkbox("VISUALS", "Other ESP", "Infobox")
local Infobox_text_color_mode = ui.new_combobox("VISUALS", "Other ESP", "Text Color", "Header", "Text", "Values")
local Infobox_colorpicker_header = ui.new_color_picker("VISUALS", "Other ESP", "Header Color", 159, 202, 43, 255)
local Infobox_colorpicker_text = ui.new_color_picker("VISUALS", "Other ESP", "Text Color", 255, 255, 255, 255)
local Infobox_colorpicker_values = ui.new_color_picker("VISUALS", "Other ESP", "Value Color", 255, 0, 60, 255)
local line_box = ui.new_combobox("VISUALS", "Other ESP", "Lines", "Color Picker", "Rainbow")
local Infobox_colorpicker = ui.new_color_picker("VISUALS", "Other ESP", "Lines", 0, 200, 255, 255)
local aimbot_ref = ui.reference("RAGE", "Aimbot", "Enabled")
local hitchance_ref = ui.reference("RAGE", "Aimbot", "Minimum hit chance")
local mindamage_ref = ui.reference("RAGE", "Aimbot", "Minimum damage")
local remove_spread_ref = ui.reference("RAGE", "Other", "Remove spread")
local anti_untrusted_ref = ui.reference("Misc", "Settings", "Anti-untrusted")

local x_pos = ui.new_slider("VISUALS", "Other ESP", "Pos X", 0, screenx, 0)
local y_pos = ui.new_slider("VISUALS", "Other ESP", "Pos Y", 0, screeny, 300)

local function draw_container(ctx, x, y, w, h)
    local c = {10, 60, 40, 40, 40, 60, 20}
    for i = 0,6,1 do
        client.draw_rectangle(ctx, x + i, y + i, w - (i * 2), h - (i * 2), c[i + 1], c[i + 1], c[i + 1], 255)
    end
end

local function clamp(min, max, current)
	if current > max then 
		current = max 
	elseif current < min then
		current = min
	end
	return floor(current)
end

function hsv_to_rgb(h, s, v, a)
  local r, g, b

  local i = floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255, a * 255
end

local function func_rgb_rainbowize(frequency, rgb_split_ratio)
    local r, g, b, a = hsv_to_rgb(globals.realtime() * frequency, 1, 1, 1)

    r = r * rgb_split_ratio
    g = g * rgb_split_ratio
    b = b * rgb_split_ratio

    return r, g, b
end

local function round(b,c)local d=10^(c or 0)return math.floor(b*d+0.5)/d end

local function get_ping(playerresource, player) return GetProp(playerresource, string.format("%03d", player)) end

local frametimes = {}
local fps_prev = 0
local last_update_time = 0

local function accumulate_fps()
	local ft = globals_absoluteframetime()
	if ft > 0 then
		table_insert(frametimes, 1, ft)
	end

	local count = #frametimes
	if count == 0 then
		return 0
	end

	local i, accum = 0, 0
	while accum < 0.5 do
		i = i + 1
		accum = accum + frametimes[i]
		if i >= count then
			break
		end
	end
	accum = accum / i
	while i < count do
		i = i + 1
		table_remove(frametimes)
	end
	
	local fps = 1 / accum
	local rt = globals_realtime()
	if abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end
	
	return floor(fps + 0.5)
end

local function disable_menu_functions()	
	SetVisible(x_pos, GetUi(Infobox)) 
	SetVisible(y_pos, GetUi(Infobox))
	SetVisible(line_box, GetUi(Infobox))
	SetVisible(Infobox_colorpicker, GetUi(Infobox))
	SetVisible(Infobox_text_color_mode, GetUi(Infobox))
	SetVisible(Infobox_colorpicker_header, GetUi(Infobox_text_color_mode) == "Header")
	SetVisible(Infobox_colorpicker_text, GetUi(Infobox_text_color_mode) == "Text")
	SetVisible(Infobox_colorpicker_values, GetUi(Infobox_text_color_mode) == "Values")

	if GetUi(Infobox) == false then
		SetVisible(Infobox_colorpicker_header, false)
		SetVisible(Infobox_colorpicker_text, false)
		SetVisible(Infobox_colorpicker_values, false)
		SetVisible(Infobox_colorpicker, false)
	else
		SetVisible(Infobox_colorpicker, GetUi(line_box) == "Color Picker")
	end
end

local function on_paint(context)
	disable_menu_functions()

	local angles_x, angles_y, angles_z = GetProp(GetLocalPlayer(), "m_angEyeAngles")
	local angles_lby = GetProp(GetLocalPlayer(), "m_flLowerBodyYawTarget")
	local velocity_x, velocity_y, velocity_z = GetProp(GetLocalPlayer(), "m_vecVelocity")

	local velocity = 0
	
	if velocity_x ~= nil or velocity_y ~= nil or velocity_z ~= nil then	
		velocity = sqrt(velocity_x * velocity_x + velocity_y * velocity_y + velocity_z * velocity_z)
	end
		
	local playerresource = GetAll("CCSPlayerResource")[1]
	local m_iKills = GetProp(playerresource, "m_iKills", GetLocalPlayer()) 
	local m_iDeaths = GetProp(playerresource, "m_iDeaths", GetLocalPlayer())

	local kdr = 0
	local kdr_converted = 0
	if not (m_iDeaths == 0) then
		kdr = m_iKills / m_iDeaths
		kdr_converted = round(kdr, 2)
	elseif not (m_iKills == 0) then
		kdr_converted = m_iKills
	end

	local ping = get_ping(playerresource, GetLocalPlayer())
	local real_ping = floor(client.latency() * 1000)

	local fps = accumulate_fps()
	local fps_r, fps_g, fps_b
	local tickrate = 1 / globals_tickinterval()
	if fps < tickrate then
		fps_r, fps_g, fps_b = 255, 0, 60
	else
		fps_r, fps_g, fps_b = 255, 255, 255
	end

	local r, g, b a = 255,0,0,255

	if GetUi(line_box) == "Color Picker" then
		r, g, b, a = GetUi(Infobox_colorpicker)
	else
		r, g, b = func_rgb_rainbowize(0.1, 1)
		a = 255
	end

	local header_r, header_g, header_b, header_a 	= GetUi(Infobox_colorpicker_header)
	local text_r, text_g, text_b, text_a 			= GetUi(Infobox_colorpicker_text)
	local values_r, values_g, values_b, values_a 	= GetUi(Infobox_colorpicker_values)

	local rage_activated = "nil" 
	local rage_r, rage_g, rage_b = 255, 255, 255

	local anti_ut_activated = "nil"
	local anti_ut_r, anti_ut_g, anti_ut_b = 255, 255, 255

	local spread_activated = "nil"
	local spread_r, spread_g, spread_b = 255, 255, 255

	local box_x = left + GetUi(x_pos)
	local box_y = top + GetUi(y_pos)
	local box_height = 152
	local box_width = 140

	if GetUi(aimbot_ref) then
		rage_activated = "On"
		rage_r, rage_g, rage_b = 255, 0, 0
		box_height = 185
	else
		rage_activated = "Off"
		rage_r, rage_g, rage_b = 0, 255, 0
		box_height = 152
	end

	if GetUi(remove_spread_ref) then
		spread_activated = "On"
		spread_r, spread_g, spread_b = 255, 0, 0
	else
		spread_activated = "Off"
		spread_r, spread_g, spread_b = 0, 255, 0
	end

	if GetUi(anti_untrusted_ref) then
		anti_ut_activated = "On"
		anti_ut_r, anti_ut_g, anti_ut_b = 0, 255, 0
	else
		anti_ut_activated = "Off"
		anti_ut_r, anti_ut_g, anti_ut_b = 255, 0, 0
	end

	local index = 1
	local value = 4

	if GetUi(Infobox) then

		draw_container(context, box_x, box_y, box_width, box_height)

		DrawText(context, box_x + (box_width / 2), box_y + ((index + 1 )* 5) + 1, header_r, header_g, header_b, header_a, "c", box_width, "Infobox")



		DrawRect(context, box_x + 9, box_y + (index * 10) + 6, box_width - 18, 1, r, g, b, a)
		index = index + 1

		DrawText(context, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "Pitch:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, floor(angles_x), "°")
		index = index + 1

		DrawText(context, box_x + 9,  box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "Yaw:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, floor(angles_y), "°")
		index = index + 1

		DrawText(context, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "LBY:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, floor(angles_lby), "°")
		index = index + 1


		value = value + 8


		DrawRect(context, box_x + 9, box_y + (index * 10) - 2, box_width - 18, 1, r, g, b, a)
		index = index + 1

		DrawText(context, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "Ping:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, clamp(0, 999, real_ping), " ms")
		index = index + 1

		DrawText(context, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "With Ping spike:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, clamp(0, 999, ping), " ms")
		index = index + 1

		DrawRect(context, box_x + 9, box_y + (index * 10) - value + 2, box_width - 18, 1, r, g, b, a)
		index = index + 1


		value = value + 8


		DrawText(context, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "Velocity:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, floor(velocity))
		index = index + 1

		DrawText(context, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "FPS:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, fps_r, fps_g, fps_b, 255, "r", box_width, fps)
		index = index + 1

		DrawRect(context, box_x + 9, box_y + (index * 10) - value + 2, box_width - 18, 1, r, g, b, a)
		index = index + 1


		value = value + 8

		
		DrawText(context, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "Kills:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, m_iKills)
		index = index + 1

		DrawText(context, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "Deaths:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, m_iDeaths)
		index = index + 1

		DrawText(context, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "KDR:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, kdr_converted)
		index = index + 1

		DrawRect(context, box_x + 9, box_y + (index * 10) - value + 2, box_width - 18, 1, r, g, b, a)
		index = index + 1


		value = value + 8

		
		DrawText(context, box_x + 10, box_y + (index * 10) - value, anti_ut_r, anti_ut_g, anti_ut_b, 255, "", box_width, "Anti Untrusted:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, anti_ut_r, anti_ut_g, anti_ut_b, 255, "r", box_width, anti_ut_activated)
		index = index + 1

		DrawText(context, box_x + 10, box_y + (index * 10) - value, rage_r, rage_g, rage_b, 255, "", box_width, "Rage:")
		DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value, rage_r, rage_g, rage_b, 255, "r", box_width, rage_activated)
		index = index + 1

		if GetUi(aimbot_ref) then

			DrawRect(context, box_x + 9, box_y + (index * 10) - value + 3, box_width - 18, 1, r, g, b, a)
			index = index + 1


			value = value + 8


			DrawText(context, box_x + 10, box_y + (index * 10) - value + 1, text_r, text_g, text_b, text_a, "", box_width, "Hitchance:")
			DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value + 1, values_r, values_g, values_b, values_a, "r", box_width, GetUi(hitchance_ref))
			index = index + 1

			DrawText(context, box_x + 10, box_y + (index * 10) - value + 1, text_r, text_g, text_b, text_a, "", box_width, "Mindmg:")
			DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value + 1, values_r, values_g, values_b, values_a, "r", box_width, GetUi(mindamage_ref))
			index = index + 1

			DrawText(context, box_x + 10, box_y + (index * 10) - value + 1, spread_r, spread_g, spread_b, 255, "", box_width, "Nospread:")
			DrawText(context, box_x + (box_width - 9), box_y + (index * 10) - value + 1, spread_r, spread_g, spread_b, 255, "r", box_width, spread_activated)
			index = index + 1
		end

	end
end

client.set_event_callback("paint", on_paint)
