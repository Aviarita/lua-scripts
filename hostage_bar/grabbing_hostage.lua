local GetUi = ui.get
local NewRef = ui.reference
local hostage_cb, hostage_clr = NewRef("visuals", "other esp", "hostages")
local AddEvent = client.set_event_callback
local GetProp = entity.get_prop
local GetAll = entity.get_all
local DrawRect = client.draw_rectangle
local DrawText = client.draw_text

local screen = {
    x, y,
    left,
    right,
    bottom,
    top
}

local curtime = globals.curtime

local function round(b, c)
    local d = 10 ^ (c or 0)
    return math.floor(b * d + 0.5) / d
end

AddEvent("paint", function(ctx)
    screen.x, screen.y = client.screen_size()
    screen.left = screen.x - screen.x
    screen.right = screen.x
    screen.bottom = screen.y
    screen.top = screen.y - screen.y
    
    local players = entity.get_players(false)
    for i = 1, #players do
        local player = players[i]
        local got_cutter = GetProp(player, "m_bHasDefuser")
        local is_grabbing_hostage = GetProp(player, "m_bIsGrabbingHostage")
        
        local hostages = GetAll("CHostage")
        for j = 1, #hostages do
            local hostage = hostages[j]
            local state = GetProp(hostage, "m_nHostageState")
            local grab_success_time = GetProp(hostage, "m_flGrabSuccessTime")
            
            local rescue_time = grab_success_time - curtime()
            --[[
                need to hardcode rescue_time_max, dont know any good way on how to get it dynamically
                but that should be a problem because the max rescue time only changes when you dont have a kit and the hostage was already picked up once
            ]] 
            local rescue_time_max = 4
            
            if got_cutter == 1 then rescue_time_max = 1 else rescue_time_max = 4 end
            
            local grabber = ""
            if is_grabbing_hostage == 1 then grabber = entity.get_player_name(player) end
            
            local r, g, b, a = GetUi(hostage_clr)
            
            if GetUi(hostage_cb) and state == 1 then
                local height = ((math.abs((screen.bottom) - screen.top) * rescue_time) / rescue_time_max)
                DrawRect(ctx, screen.left + 1, 0, screen.left + 20, screen.bottom, 32, 32, 32, 50)
                local s = 128 if a < 128 then s = a end
                DrawRect(ctx, screen.left + 1, screen.bottom - height, screen.left + 18, screen.bottom, r, g, b, s)
                DrawText(ctx, screen.left + 5, screen.top + 5, r, g, b, a, "+", 999, "Grabbing hostage: " .. round(rescue_time, 1))
                DrawText(ctx, screen.left + 5, screen.top + 30, r, g, b, a, "+", 999, grabber)
            end
        end
    end
end)
