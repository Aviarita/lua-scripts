**Mini sdk for the gamesense lua api**

This is a "mini sdk" i wrote for the gamesense lua api, it makes development of some scripts easier.

Things this "sdk" got:
1. Entity class
2. Player class
3. Localplayer class
4. Weapon class
5. Playerresource class
6. Global playerresource class
7. Gamerulesproxy class

![screen](https://third-rei.ch/ycfN3YS8O4.png)
**Used code in the screenshot**
```lua
require( "lua sdk" )

local function draw_debug_infos(ctx, entity_index)
    local player = Player(entity_index) -- create a new player instance for entity_index
    local gbb = player:get_bounding_box(ctx)
    if gbb.botX == nil then return end

    local local_player = LocalPlayer() -- create a new instance for the local player
    
    local weapons = player:get_all_weapons() -- returns a table with the indexes of every weapon the player has equiped
    for i = 1, #weapons do
        local weapons = weapons[i]
        local r, g, b = 255, 255, 255
        -- checks if any weapon is the same as the active weapon of the player and changes the color
        if weapons:get_index() == player:get_active_weapon():get_index() then 
            r, g, b = 215, 215, 0
        else
            r, g, b = 255, 255, 255
        end
        renderer.text(gbb.botX - (gbb.width / 1.5), gbb.botY + (i * 10), r, g, b, 255, "cb", 999, "", weapons:get_name()) 
        renderer.text(gbb.botX - (gbb.width / 8), gbb.botY + (i * 10), r, g, b, 255, "cb", 999, "", weapons:get_current_ammo()) 
    end

    renderer.text(gbb.botX + 5, gbb.topY,      255, 255, 255, gbb.alpha * 255, "b", 999, "Name: ",        player:get_name())
    renderer.text(gbb.botX + 5, gbb.topY + 10, 255, 255, 255, gbb.alpha * 255, "b", 999, "Entindex: ",    player:get_index())
    renderer.text(gbb.botX + 5, gbb.topY + 20, 255, 255, 255, gbb.alpha * 255, "b", 999, "Enemy: ",       player:is_enemy())
    renderer.text(gbb.botX + 5, gbb.topY + 30, 255, 255, 255, gbb.alpha * 255, "b", 999, "Health: ",      player:get_health())
    renderer.text(gbb.botX + 5, gbb.topY + 40, 255, 255, 255, gbb.alpha * 255, "b", 999, "Kills: ",       player:playerresource():get_kills())
    renderer.text(gbb.botX + 5, gbb.topY + 50, 255, 255, 255, gbb.alpha * 255, "b", 999, "Deaths: ",      player:playerresource():get_deaths())
    renderer.text(gbb.botX + 5, gbb.topY + 60, 255, 255, 255, gbb.alpha * 255, "b", 999, "Score: ",       player:playerresource():get_score())
    renderer.text(gbb.botX + 5, gbb.topY + 70, 255, 255, 255, gbb.alpha * 255, "b", 999, "MM Wins: ",     player:playerresource():get_matchmaking_wins())
    renderer.text(gbb.botX + 5, gbb.topY + 80, 255, 255, 255, gbb.alpha * 255, "b", 999, "MM Rank: ",     player:playerresource():get_matchmaking_rank())

end
client.set_event_callback("paint", function(ctx)
	local players = entity.get_players(true)
	for i=1, #players do
		local player = players[i]
		draw_debug_infos(ctx, player)
	end
    local gamerules = Gamerulesproxy()
    renderer.indicator(255, 255, 255, 255, "is_valve_ds: ", gamerules:is_valve_ds())
    renderer.indicator(255, 255, 255, 255, "is_freezetime: ", gamerules:is_freezetime())
    renderer.indicator(255, 255, 255, 255, "is_queued_for_matchmaking: ", gamerules:is_queued_for_matchmaking())
    renderer.indicator(255, 255, 255, 255, "is_bomb_dropped: ", gamerules:is_bomb_dropped())
    renderer.indicator(255, 255, 255, 255, "is_bomb_planted: ", gamerules:is_bomb_planted())
end)
```
