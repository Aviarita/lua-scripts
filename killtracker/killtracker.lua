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

local AddEvent = client.set_event_callback

local uidToEntIndex = client.userid_to_entindex

-- client.draw_text(paint_ctx, x, y, r, g, b, a, flags, max_width, ...) --
local DrawText = client.draw_text
local DrawRect = client.draw_rectangle

local kill_tracker = ui.new_checkbox("VISUALS", "Other ESP", "Kill Tracker")
local kill_tracker_text_color_mode = ui.new_combobox("VISUALS", "Other ESP", "Text Color", "Header", "Text", "Values", "Lines")
local kill_tracker_colorpicker_header = ui.new_color_picker("VISUALS", "Other ESP", "Header Color", 159, 202, 43, 255)
local kill_tracker_colorpicker_text = ui.new_color_picker("VISUALS", "Other ESP", "Text Color", 255, 255, 255, 255)
local kill_tracker_colorpicker_values = ui.new_color_picker("VISUALS", "Other ESP", "Value Color", 255, 0, 60, 255)
local kill_tracker_colorpicker_lines = ui.new_color_picker("VISUALS", "Other ESP", "Lines", 255, 0, 60, 255)

local x_pos = ui.new_slider("VISUALS", "Other ESP", "Pos X", 0, screenx, 0)
local y_pos = ui.new_slider("VISUALS", "Other ESP", "Pos Y", 0, screeny, 300)

local function m_iTeamNum(entity_index)
	return entity.get_prop(entity_index, "m_iTeamNum")
end

local function draw_container(ctx, x, y, w, h)
    local c = {10, 60, 40, 40, 40, 60, 20}
    for i = 0,6,1 do
        client.draw_rectangle(ctx, x + i, y + i, w - (i * 2), h - (i * 2), c[i + 1], c[i + 1], c[i + 1], 255)
    end
end

local function round(b,c)local d=10^(c or 0)return math.floor(b*d+0.5)/d end

local function disable_menu_functions()	
	SetVisible(x_pos, GetUi(kill_tracker)) 
	SetVisible(y_pos, GetUi(kill_tracker))
	SetVisible(kill_tracker_text_color_mode, GetUi(kill_tracker))
	SetVisible(kill_tracker_colorpicker_header, GetUi(kill_tracker_text_color_mode) == "Header")
	SetVisible(kill_tracker_colorpicker_text, GetUi(kill_tracker_text_color_mode) == "Text")
	SetVisible(kill_tracker_colorpicker_values, GetUi(kill_tracker_text_color_mode) == "Values")
	SetVisible(kill_tracker_colorpicker_lines, GetUi(kill_tracker_text_color_mode) == "Lines")

	if GetUi(kill_tracker) == false then
		SetVisible(kill_tracker_colorpicker_header, false)
		SetVisible(kill_tracker_colorpicker_text, false)
		SetVisible(kill_tracker_colorpicker_values, false)
		SetVisible(kill_tracker_colorpicker_lines, false)
	end
end

local headshots = 0
local non_headshots = 0

AddEvent("paint", function(ctx)
	disable_menu_functions()

	local playerresource = GetAll("CCSPlayerResource")[1]
	local m_iKills = GetProp(playerresource, "m_iKills", GetLocalPlayer()) 
	local m_iDeaths = GetProp(playerresource, "m_iDeaths", GetLocalPlayer())

	local kdr_converted = 0
	if m_iDeaths ~= 0 then
		local temp = m_iKills / m_iDeaths
		kdr_converted = round(temp, 2)
	elseif m_iKills ~= 0 then
		kdr_converted = m_iKills
	end

	local headshot_percentage = 0

	if headshots ~= 0 then
		local temp = headshots / m_iKills
		headshot_percentage = round(temp, 2) * 100
	elseif m_iKills ~= 0 then
		headshot_percentage = 0
	end

	local header_r, header_g, header_b, header_a 	= GetUi(kill_tracker_colorpicker_header)
	local text_r, text_g, text_b, text_a 			= GetUi(kill_tracker_colorpicker_text)
	local values_r, values_g, values_b, values_a 	= GetUi(kill_tracker_colorpicker_values)
	local lines_r, lines_g, lines_b, lines_a = GetUi(kill_tracker_colorpicker_lines)


	local box_x = left + GetUi(x_pos)
	local box_y = top + GetUi(y_pos)
	local box_height = 88
	local box_width = 140

	local index = 1
	local value = 4

	if GetUi(kill_tracker) then

		draw_container(ctx, box_x, box_y, box_width, box_height)

		DrawText(ctx, box_x + (box_width / 2), box_y + ((index + 1 )* 5) + 1, header_r, header_g, header_b, header_a, "c", box_width, "Kill Tracker")

		DrawRect(ctx, box_x + 9, box_y + (index * 10) + 6, box_width - 18, 1, lines_r, lines_g, lines_b, lines_a)
		index = index + 1
		
		DrawText(ctx, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "Kills:")
		DrawText(ctx, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, m_iKills)
		index = index + 1

		DrawText(ctx, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "Deaths:")
		DrawText(ctx, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, m_iDeaths)
		index = index + 1

		DrawText(ctx, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "KDR:")
		DrawText(ctx, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, kdr_converted)
		index = index + 1

		DrawText(ctx, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "HS:")
		DrawText(ctx, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width,headshot_percentage, "%")
		index = index + 1

		DrawText(ctx, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "Headshots:")
		DrawText(ctx, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, headshots)
		index = index + 1

		DrawText(ctx, box_x + 10, box_y + (index * 10) - value, text_r, text_g, text_b, text_a, "", box_width, "Baim kills:")
		DrawText(ctx, box_x + (box_width - 9), box_y + (index * 10) - value, values_r, values_g, values_b, values_a, "r", box_width, non_headshots)
		index = index + 1

		DrawRect(ctx, box_x + 9, box_y + (index * 10) - value + 2, box_width - 18, 1, lines_r, lines_g, lines_b, lines_a)
		index = index + 1
	end
end)

AddEvent("begin_new_match", function() -- getho way so it resets baim kills and headshots after a new match begins or a game is restarted
	headshots = 0
	non_headshots = 0
end)

-- credits to sapphyrus for finding the event because im to dumb to do proper search -.-
AddEvent("player_connect_full", function(event)
    if uidToEntIndex(event.userid) == GetLocalPlayer() then
       	headshots = 0
		non_headshots = 0
    end
end)
