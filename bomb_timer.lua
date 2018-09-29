local GetUi = ui.get
local NewCheckbox = ui.new_checkbox
local GetLocalPlayer = entity.get_local_player
local checkbox = NewCheckbox("visuals", "other esp", "Bomb timer")
local AddEvent = client.set_event_callback
local GetProp = entity.get_prop
local GetAll = entity.get_all

local screen = {
    x, y,
    left,
    right,
    bottom,
    top
}

local DrawText = client.draw_text
local DrawRect = client.draw_rectangle

-- ghetto but works GetProp(player, "m_bHasDefuser") didnt really gave me the result i wanted --
-- this only breaks when you reload the script after someone already got a defuser

local defusers = 0

AddEvent("item_pickup", function(e)
    if e.item == "defuser" then
        defusers = defusers + 1
    end
end)

AddEvent("item_remove", function(e)
    if e.item == "defuser" and defusers >= 1 then
        defusers = defusers - 1
    end
end)

local function get_bomb_time(bomb)
    local bomb_time = GetProp(bomb, "m_flC4Blow") - globals.curtime()
    if bomb_time == nil then return 0 end
    if bomb_time > 0 then
        return bomb_time
    end
    return 0
end

local function can_not_defuse(player, bomb)
    local bomb_time = GetProp(bomb, "m_flC4Blow") - globals.curtime()
    if bomb_time == nil then return false end
    return (bomb_time < 5 and defusers >= 1) or (bomb_time < 10 and defusers == 0)
end

local function get_defuser(bomb)
    return GetProp(bomb, "m_hBombDefuser")
end

AddEvent("paint", function(ctx)

    screen.x, screen.y = client.screen_size()
    screen.left = screen.x - screen.x
    screen.right = screen.x
    screen.bottom = screen.y
    screen.top = screen.y - screen.y

    local bomb = GetAll("CPlantedC4")[1]
    if bomb == nil then return false end

    if GetProp(bomb, "m_bBombDefused") == 1 then return end
    
    local players = entity.get_players(false)
    for i = 0, #players do
        local player = players[i]
        
        local r, g, b = 0, 255, 0
        
        if can_not_defuse(player, bomb) then
            r, g, b = 255, 0, 0
        else
            r, g, b = 75, 230, 64
        end
        
        if GetUi(checkbox) and get_bomb_time(bomb) ~= 0 then
            if get_defuser(bomb) ~= nil then return end
            local bomb_time = get_bomb_time(bomb)
            local bomb_time_max = client.get_cvar("mp_c4timer")
            local height = ((math.abs((screen.bottom) - screen.top) * bomb_time) / bomb_time_max)
            DrawRect(ctx, screen.left, 0, screen.left + 20, screen.bottom, 32, 32, 32, 50)
            DrawRect(ctx, screen.left + 1, screen.bottom - height, screen.left + 18, screen.bottom, r, g, b, 80)
        end
    end
end)
