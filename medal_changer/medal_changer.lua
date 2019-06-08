local get_prop = entity.get_prop
local set_prop = entity.set_prop
local get_all = entity.get_all
local get_lp = entity.get_local_player

local vis = ui.set_visible
local get = ui.get
local set = ui.set
local get_name = ui.name
local new_checkbox = ui.new_checkbox
local new_textbox = ui.new_textbox

local settings = {
    {
        new_checkbox("lua", "b", "Enable coin Changer"),
        new_textbox("lua", "b", "\ncoin_changer"),
        "m_nActiveCoinRank",
        0
    },
    {
        new_checkbox("lua", "b", "Enable Private rank"),
        new_textbox("lua", "b", "\nprivate_rank"),
        "m_nPersonaDataPublicLevel",
        0
    },
    {
        new_checkbox("lua", "b", "Enable Music kit"),
        new_textbox("lua", "b", "\nmusic_kit"),
        "m_nMusicID",
        0
    },
}

for i=1,#settings do
    local setting = settings[i]
    vis(setting[2], get(setting[1]))
    ui.set_callback(setting[1], function(s)
        vis(setting[2], get(s))
    end)
end

local function GetProp(prop)
    local player_resource = get_all("CCSPlayerResource")[1]
    return get_prop(player_resource, prop, get_lp())
end

local function SetProp(prop, menu_item, value)
    local player_resource = get_all("CCSPlayerResource")[1]

    if menu_item ~= nil then
        set_prop(player_resource, prop, get(menu_item), get_lp())
    elseif value ~= nil then
        set_prop(player_resource, prop, value, get_lp())
    end
end

local backup_values = true

local function on_net_update_end()

    if backup_values == true then
        for i=1,#settings do
            local setting = settings[i]
            setting[4] = GetProp(setting[3])
        end
        backup_values = false
    end

    for i=1,#settings do
        local setting = settings[i]
        if get(setting[1]) == true then 
            SetProp(setting[3], setting[2])
        else
            SetProp(setting[3], nil, setting[4])
        end
    end

end
client.set_event_callback("net_update_end", on_net_update_end)
