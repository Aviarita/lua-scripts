local GetUi = ui.get
local SetUi = ui.set
local SetCallback = ui.set_callback
local NewCheckbox = ui.new_checkbox
local NewColor = ui.new_color_picker
local NewRef = ui.reference
local SetVisible = ui.set_visible

local AddEvent = client.set_event_callback

local menu_color = NewRef("misc", "settings", "Menu color")
local cc = { r, g, b, a }
cc.r, cc.g, cc.b, cc.a = GetUi(menu_color)

local new_menu_color_check = NewCheckbox("misc", "settings", "Menu Color")
local new_menu_color = NewColor("misc", "settings", "Menu Color")

SetVisible(menu_color, true)
SetVisible(new_menu_color, false)

local function change_menu_color()
	client.delay_call(0.0001, change_menu_color)
	if not GetUi(new_menu_color_check) then return end
	local r, g, b, a = GetUi(new_menu_color)
	SetUi(menu_color, r, g, b, a)
end
change_menu_color()

SetCallback(new_menu_color_check, function()
	SetVisible(menu_color, not GetUi(new_menu_color_check))
	SetVisible(new_menu_color, GetUi(new_menu_color_check))
	SetUi(menu_color, cc.r,cc.g,cc.b,cc.a)
	cc.r, cc.g, cc.b, cc.a = GetUi(menu_color)
end)
