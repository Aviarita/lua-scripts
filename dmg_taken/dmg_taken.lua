local GetUi = ui.get
local SetUi = ui.set
local NewSlider = ui.new_slider
local NewCheckbox = ui.new_checkbox
local NewColor = ui.new_color_picker
local NewMultiselect = ui.new_multiselect
local NewRef = ui.reference
local SetVisible = ui.set_visible
local SetCallback = ui.set_callback

local UidToEntIndex = client.userid_to_entindex
local GetPlayerName = entity.get_player_name
local GetLocalPlayer = entity.get_local_player

local Log = client.log

local AddEvent = client.set_event_callback

local DrawText = client.draw_text
local DrawRect = client.draw_rectangle
local DrawLine = client.draw_line

local screen = {
    x, y,
}

screen.x, screen.y = client.screen_size()

local ui = {
    multiselect = NewMultiselect("misc", "miscellaneous", "Damage taken indicator", {"Onscreen Text", "Skeleton", "Container", "Console"}),
    color = NewColor("misc", "miscellaneous", "Damage taken indicator", 200, 200, 200, 255),
    box_x = NewSlider("misc", "miscellaneous", "Container position x", 0, screen.x, 300),
    box_y = NewSlider("misc", "miscellaneous", "Container position y", 0, screen.y, 300), 
    skelet_x = NewSlider("misc", "miscellaneous", "Skeleton position x", 0, screen.x, 300),
    skelet_y = NewSlider("misc", "miscellaneous", "Skeleton position y", 0, screen.y, 600),
}

-- credits to abbie --
local function draw_container(ctx, x, y, w, h, texture)
    texture = texture or false
    local c = {10, 60, 40, 40, 40, 60, 25}
    for i = 0, 6, 1 do
        DrawRect(ctx, x + i, y + i, w - (i * 2), h - (i * 2), c[i + 1], c[i + 1], c[i + 1], 255)
    end
    if texture == true then
        for i = 1, w - 12 do
            if i % 4 == 0 then
                for k = 1, h - 14 do
                    if k % 4 == 0 then
                        DrawRect(ctx, x + i + 4, y + k + 3, 1, 3, 15, 15, 15, 255)
                    end
                end
            end
            
            if i % 4 == 2 then
                for k = 1, h - 14 do
                    if k % 4 == 0 then
                        DrawRect(ctx, x + i + 4, y + k + 5, 1, 3, 15, 15, 15, 255)
                    end
                end
            end
        end
    end
end

-- credits to sapphy rus --
local function contains(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

local hitgroup_names = {
    "body", "head", "chest",
    "stomach", "left arm", "right arm",
    "left leg", "right leg", "neck",
    "?", "gear",
}

local player_hurt = {
    attacker,
    health,
    armor,
    weapon,
    dmg_health,
    dmg_armor,
    hitgroup,
    hitbox_hit,
}

local logs = {}
AddEvent("player_hurt", function(event)
    
    local userid, attacker, health, armor, weapon, dmg_health, dmg_armor, hitgroup = event.userid, event.attacker, event.health, event.armor, event.weapon, event.dmg_health, event.dmg_armor, event.hitgroup
    
    if userid == nil or attacker == nil or hitgroup < 0 or hitgroup > 10 or dmg_health == nil or health == nil then
        return
    end
    
    if UidToEntIndex(userid) == GetLocalPlayer() then

        player_hurt.attacker = UidToEntIndex(attacker)
        player_hurt.health = health
        player_hurt.armor = armor
        player_hurt.weapon = weapon
        player_hurt.dmg_health = dmg_health
        player_hurt.dmg_armor = dmg_armor
        player_hurt.hitgroup = hitgroup
        player_hurt.hitbox_hit = hitgroup_names[hitgroup + 1]

        local enemy_name = GetPlayerName(player_hurt.attacker)
    
    	local fixed_name = enemy_name
    	
    	if enemy_name:len() > 10 then
    	    fixed_name = string.sub(enemy_name, 0, 10)
    	end
        
        if player_hurt.hitbox_hit then
            local message = ("Got hit by " .. fixed_name ..
                " in the " .. player_hurt.hitbox_hit ..
                " for " .. player_hurt.dmg_health ..
            " damage (" .. player_hurt.health .. " health remaining)")

            if contains(GetUi(ui.multiselect), "Console") then
                Log(message)
            end
        	
            table.insert(logs, message)
        end
    end
end)

local height_add = 0
local realtime = globals.realtime
local lasttime = realtime()
local lasttime2 = realtime()

AddEvent("paint", function(ctx)

    if screen.x ~= screen.x or screen.y ~= screen.y then
        screen.x, screen.y = client.screen_size()
    end
    
    local activation_type = GetUi(ui.multiselect)

    SetVisible(ui.box_x, contains(activation_type, "Container"))
    SetVisible(ui.box_y, contains(activation_type, "Container")) 
    SetVisible(ui.skelet_x, contains(activation_type, "Skeleton"))
    SetVisible(ui.skelet_y, contains(activation_type, "Skeleton"))

    local box_x = GetUi(ui.box_x)
    local box_y = GetUi(ui.box_y)
    local skeleton_x = GetUi(ui.skelet_x)
    local skeleton_y = GetUi(ui.skelet_y)

    local lp_health = entity.get_prop(GetLocalPlayer(), "m_iHealth")

    local now2 = realtime()
    if lasttime2 < now2 - 2 then
    	player_hurt.hitgroup = -1
    	lasttime2 = now2
    end
    
    if contains(activation_type, "Onscreen Text") then
    	local r, g, b = 24, 200, 0
    	if player_hurt.dmg_health ~= nil and player_hurt.dmg_health > lp_health then
    		r, g, b = 255, 64, 0
    	end

        if player_hurt.hitgroup == 1 then -- head
        	DrawText(ctx, screen.x - (screen.x / 1.85), 150, r, g, b, 255, "+", 999, "-" .. player_hurt.dmg_health .. " HEAD")
        elseif player_hurt.hitgroup == 8 then -- neck
        	DrawText(ctx, screen.x - (screen.x / 1.75), 150, r, g, b, 255, "+", 999, "-" .. player_hurt.dmg_health .. " Neck")
    	elseif player_hurt.hitgroup == 0 then  -- body
        	DrawText(ctx, screen.x - (screen.x / 1.85), screen.y - (screen.y / 1.6), r, g, b, 255, "+", 999, "-" .. player_hurt.dmg_health .. " BODY")
    	elseif player_hurt.hitgroup == 2 then  -- chest
        	DrawText(ctx, screen.x - (screen.x / 1.85), screen.y - (screen.y / 1.78), r, g, b, 255, "+", 999, "-" .. player_hurt.dmg_health .. " CHEST")
    	elseif player_hurt.hitgroup == 3 then  -- stomach
        	DrawText(ctx, screen.x - (screen.x / 1.85), screen.y - (screen.y / 2), r, g, b, 255, "+", 999, "-" .. player_hurt.dmg_health .. " Stomach")
    	elseif player_hurt.hitgroup == 4 then -- left arm
        	DrawText(ctx, screen.x - (screen.x / 1.5), screen.y - (screen.y / 1.5), r, g, b, 255, "+", 999, "-" .. player_hurt.dmg_health .. " LEFT ARM")
    	elseif player_hurt.hitgroup == 5 then -- right arm
        	DrawText(ctx, screen.x - (screen.x / 2.5), screen.y - (screen.y / 1.5), r, g, b, 255, "+", 999, "-" .. player_hurt.dmg_health .. " RIGHT ARM")
    	elseif player_hurt.hitgroup == 6 then -- left leg
        	DrawText(ctx, screen.x - (screen.x / 1.55), screen.y - (screen.y / 2.8), r, g, b, 255, "+", 999, "-" .. player_hurt.dmg_health .. " LEFT LEG")
    	elseif player_hurt.hitgroup == 7 then -- right leg
        	DrawText(ctx, screen.x - (screen.x / 2.25), screen.y - (screen.y / 2.8), r, g, b, 255, "+", 999, "-" .. player_hurt.dmg_health .. " RIGHT LEG")
    	end
    end
    if contains(activation_type, "Skeleton") then -- dont look at the code pls
    	local r, g, b, a = 255, 255, 255, 255
    	draw_container(ctx, skeleton_x, skeleton_y, 150, 250)

    	if player_hurt.hitgroup == 8 or player_hurt.hitgroup == 1 then -- head/neck
    		client.draw_circle(ctx, skeleton_x + 75, skeleton_y + 35, 200, 0, 0, 255, 20, 1, 1)
    		DrawLine(ctx, skeleton_x + 74, skeleton_y + 55, skeleton_x + 74, skeleton_y + 175, 200, 200, 200, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 55, skeleton_x + 75, skeleton_y + 175, 200, 200, 200, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 65, skeleton_x + 35, skeleton_y + 130, 200, 200, 200, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 67, skeleton_x + 114, skeleton_y + 130, 200, 200, 200, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 35, skeleton_y + 240, 200, 200, 200, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 110, skeleton_y + 240, 200, 200, 200, 255)
    	elseif player_hurt.hitgroup == 0 or player_hurt.hitgroup == 2 or player_hurt.hitgroup == 3 then  -- body
    		client.draw_circle(ctx, skeleton_x + 75, skeleton_y + 35, 200, 200, 200, 255, 20, 1, 1)
    		DrawLine(ctx, skeleton_x + 74, skeleton_y + 55, skeleton_x + 74, skeleton_y + 175,   200, 0, 0, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 55, skeleton_x + 75, skeleton_y + 175,   200, 0, 0, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 65, skeleton_x + 35, skeleton_y + 130,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 67, skeleton_x + 114, skeleton_y + 130,  200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 35, skeleton_y + 240,  200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 110, skeleton_y + 240, 200, 255, 255, 255)
    	elseif player_hurt.hitgroup == 4 then -- left arm
    		client.draw_circle(ctx, skeleton_x + 75, skeleton_y + 35, 200, 200, 200, 255, 20, 1, 1)
    		DrawLine(ctx, skeleton_x + 74, skeleton_y + 55, skeleton_x + 74, skeleton_y + 175,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 55, skeleton_x + 75, skeleton_y + 175,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 65, skeleton_x + 35, skeleton_y + 130,   200, 0, 0, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 67, skeleton_x + 114, skeleton_y + 130,  200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 35, skeleton_y + 240,  200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 110, skeleton_y + 240, 200, 255, 255, 255)
    	elseif player_hurt.hitgroup == 5 then -- right arm
    		client.draw_circle(ctx, skeleton_x + 75, skeleton_y + 35, 200, 200, 200, 255, 20, 1, 1)
    		DrawLine(ctx, skeleton_x + 74, skeleton_y + 55, skeleton_x + 74, skeleton_y + 175,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 55, skeleton_x + 75, skeleton_y + 175,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 65, skeleton_x + 35, skeleton_y + 130,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 67, skeleton_x + 114, skeleton_y + 130,  200, 0, 0, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 35, skeleton_y + 240,  200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 110, skeleton_y + 240, 200, 255, 255, 255)
    	elseif player_hurt.hitgroup == 6 then -- left leg
    		client.draw_circle(ctx, skeleton_x + 75, skeleton_y + 35, 200, 200, 200, 255, 20, 1, 1)
    		DrawLine(ctx, skeleton_x + 74, skeleton_y + 55, skeleton_x + 74, skeleton_y + 175,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 55, skeleton_x + 75, skeleton_y + 175,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 65, skeleton_x + 35, skeleton_y + 130,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 67, skeleton_x + 114, skeleton_y + 130,  200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 35, skeleton_y + 240,  200, 0, 0, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 110, skeleton_y + 240, 200, 255, 255, 255)
    	elseif player_hurt.hitgroup == 7 then -- right leg
    		client.draw_circle(ctx, skeleton_x + 75, skeleton_y + 35, 200, 200, 200, 255, 20, 1, 1)
    		DrawLine(ctx, skeleton_x + 74, skeleton_y + 55, skeleton_x + 74, skeleton_y + 175,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 55, skeleton_x + 75, skeleton_y + 175,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 65, skeleton_x + 35, skeleton_y + 130,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 67, skeleton_x + 114, skeleton_y + 130,  200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 35, skeleton_y + 240,  200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 110, skeleton_y + 240, 200, 0, 0, 255)
    	else
    		client.draw_circle(ctx, skeleton_x + 75, skeleton_y + 35, 200, 200, 200, 255, 20, 1, 1)
    		DrawLine(ctx, skeleton_x + 74, skeleton_y + 55, skeleton_x + 74, skeleton_y + 175,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 55, skeleton_x + 75, skeleton_y + 175,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 65, skeleton_x + 35, skeleton_y + 130,   200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 67, skeleton_x + 114, skeleton_y + 130,  200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 35, skeleton_y + 240,  200, 255, 255, 255)
    		DrawLine(ctx, skeleton_x + 75, skeleton_y + 175, skeleton_x + 110, skeleton_y + 240, 200, 255, 255, 255)
    	end
    end
    if contains(activation_type, "Container") then
    	local r, g, b, a = GetUi(ui.color)
       
        draw_container(ctx, box_x, box_y, 410, 30 + height_add + 2)
        DrawText(ctx, box_x + 180, box_y + 7, 103, 170, 6, 255, "b", 999, "Damage log")
        for i = 1, #logs do
           	DrawText(ctx, box_x + 10, box_y + 10 + (10 * i), r, g, b, a, "", 400, logs[i])
           	if i > 6 then
           		table.remove( logs, 1)
       	 	end
       	 	height_add = (i * 10)
    		local now = realtime()
    		if lasttime < now - 1 then
    		    table.remove(logs, 1) 
    		    lasttime = now
    		end
        end       	
    end
    
end)
