local GetUi = ui.get 
local SetUi = ui.set
local SetVisible = ui.set_visible
local uidToEntIndex = client.userid_to_entindex
local LocalPlayer = entity.get_local_player

local when_to_randomize = ui.new_multiselect("AA", "Other", "When to randomize", "On fire", "On hit")

local randomize_on_fire = ui.new_multiselect("AA", "Other", "Randomize on fire", "Pitch", "Yaw", "Yaw jitter", "Yaw while running", "Fake yaw", "Freestanding real yaw offset", "Freestanding fake yaw offset")
local randomize_on_hit = ui.new_multiselect("AA", "Other", "Randomize on hit", "Pitch", "Yaw", "Yaw jitter", "Yaw while running", "Fake yaw", "Freestanding real yaw offset", "Freestanding fake yaw offset")


local pitch_ref = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local yaw_ref = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local yaw_jitter_ref = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local yaw_while_running_ref = ui.reference("AA", "Anti-aimbot angles", "Yaw while running")
local fake_yaw_ref = ui.reference("AA", "Anti-aimbot angles", "Fake yaw")

local freestand_real_ref = ui.reference("AA", "Anti-aimbot angles", "Freestanding real yaw offset")
local freestand_fake_ref = ui.reference("AA", "Anti-aimbot angles", "Freestanding fake yaw offset")

local pitch = {
	"Default",
	"Up",
	"Down",
	"Minimal"
}

local yaw = {
	"180",
	"Jitter",
	"Spin",
	"Sideways",
	"Static",
	"180 Z",
	"Crosshair"
}

local yaw_jitter = {
	"Off",
	"Offset",
	"Center",
	"Random"
}

local yaw_running = {
	"180",
	"Jitter",
	"Spin",
	"Sideways",
	"Local view",
	"Static",
	"Opposite"
}

local fake_yaw = {
	"Default",
	"180",
	"Jitter",
	"Spin",
	"Sideways",
	"Random",
	"Local view",
	"Static",
	"Opposite",
}

local function contains(table, val)
	for i=1,#table do
		if table[i] == val then 
			return true
		end
	end
	return false
end


local function randomize_aa(menu_item)

	local random_pitch = pitch[client.random_int(1,4)]
	local random_yaw = yaw[client.random_int(1,7)]
	local random_yaw_jitter = yaw_jitter[client.random_int(1,4)]
	local random_yaw_while_running = yaw_running[client.random_int(1,7)]
	local random_fake_yaw = fake_yaw[client.random_int(1,8)]
	local random_freestand_real = client.random_int(-90,90)
	local random_freestand_fake = client.random_int(-90,90)

	local selected_item = GetUi(menu_item)

	for i=1, #selected_item do
		if selected_item[i] == "Pitch" then
			SetUi(pitch_ref, random_pitch)

		elseif selected_item[i] == "Yaw" then
			SetUi(yaw_ref, random_yaw)

		elseif selected_item[i] == "Yaw jitter" then
			SetUi(yaw_jitter_ref, random_yaw_jitter)

		elseif selected_item[i] == "Yaw while running" then
			SetUi(yaw_while_running_ref, random_yaw_while_running)

		elseif selected_item[i] == "Fake yaw" then
			SetUi(fake_yaw_ref, random_fake_yaw)

		elseif selected_item[i] == "Freestanding real yaw offset" then
			SetUi(freestand_real_ref, random_freestand_real)

		elseif selected_item[i] == "Freestanding fake yaw offset" then
			SetUi(freestand_fake_ref, random_freestand_fake)
		end
	end
end


local function on_player_hurt(event)

	local userID = event.userid 
	local userEntIndex = uidToEntIndex(userID)

	if userEntIndex == LocalPlayer() then
		local randomize_mode = GetUi(when_to_randomize)
	
		for i=1, #randomize_mode do
			if randomize_mode[i] == "On hit" then
				randomize_aa(randomize_on_hit)
			end
		end
	end
end


local function on_aim_fire(event)
	
	local randomize_mode = GetUi(when_to_randomize)
	
	for i=1, #randomize_mode do
		if randomize_mode[i] == "On fire" then
			randomize_aa(randomize_on_fire)
		end
	end
end

local function on_paint(ctx)
	local value = GetUi(when_to_randomize)
	SetVisible(randomize_on_fire, contains(value, "On fire"))
	SetVisible(randomize_on_hit, contains(value, "On hit"))
end

client.set_event_callback("player_hurt", on_player_hurt)
client.set_event_callback("aim_fire", on_aim_fire)
client.set_event_callback("paint", on_paint)
