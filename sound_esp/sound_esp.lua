-----------------------------------------------------------------
local sound = "ui/beepclear" -- Thats the sound you will heart --
----------------------------------------------------------------- 

local checkbox = ui.new_checkbox("visuals", "player esp", "Sound esp")
local min_distance = ui.new_slider("visuals", "player esp", "Min distance", 0, 500, 100, true, "ft")
local volume = ui.new_slider("visuals", "player esp", "Volume", 0, 100, 50, true, "%")

local GetUi = ui.get
local SetUi = ui.set
local GetLocalPlayer = entity.get_local_player
local GetProp = entity.get_prop
local AddEvent = client.set_event_callback
local MaxPlayers = globals.maxplayers

local function distance3d(a, b) 
    return math.ceil(math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2) + math.pow(a.z - b.z, 2)) * 0.0254 / 0.3048) 
end

local last_tickcount = 0

-- credits to sapphyrus --
local function play_sound(filename, volume)
    local amount = math.floor(volume)
    local more = volume % amount == 0 and 0 or 1
    for i = 1, amount+more do
        local volume_temp = 1
        if i == amount+more then
            volume_temp = volume+1-i
        end
        client.exec("playvol ", filename, " ", volume_temp)
    end
end

AddEvent("run_command", function()
    if GetUi(checkbox) then
        
        local lp_position = {x, y, z}
        lp_position.x, lp_position.y, lp_position.z = GetProp(GetLocalPlayer(), "m_vecOrigin")
       
        local players = entity.get_players(true)
        
        for i = 1, #players do
            local player = players[i]
           
            local enemy_position = {x, y, z}
            
            enemy_position.x, enemy_position.y, enemy_position.z = GetProp(player, "m_vecOrigin")
            local distance = distance3d(lp_position, enemy_position)

            local spam_delay_value = distance / 35
            local current_tickcount = globals.tickcount()
            if current_tickcount - last_tickcount < spam_delay_value then
                return
            elseif current_tickcount - last_tickcount > spam_delay_value then
                last_tickcount = current_tickcount
            end
            
            if distance < GetUi(min_distance) then
                play_sound(sound, GetUi(volume) / 100)
            end
        end
    end
end)
