local GetUi = ui.get
local NewCombo = ui.new_combobox
local NewSlider = ui.new_slider
local GetAll = entity.get_all
local GetProp = entity.get_prop
local SetProp = entity.set_prop
local AddEvent = client.set_event_callback

local chicken_outfit = NewCombo("visuals", "effects", "Chicken outfit", {
    "Default Chicken",
    "Party Chicken",
    "Ghost Chicken",
    "Festive Chicken",
    "Easter Chicken",
    "Jack-o'-Chicken"
})

local chicken_size = NewSlider("visuals", "effects", "Chicken size", 10, 1500, 100, true, "", .01)

AddEvent("paint", function()
    
    local chickens = GetAll("CChicken")
    
    if chickens == nil then return end
    
    for i = 1, #chickens do
        local chicken = chickens[i]
        local outfit = GetUi(chicken_outfit)
        
        SetProp(chicken, "m_flModelScale", GetUi(chicken_size) * .01)
        
        if outfit == "Default Chicken" then
            SetProp(chicken, "m_nBody", 0)
            
        elseif outfit == "Party Chicken" then
            SetProp(chicken, "m_nBody", 1)
            
        elseif outfit == "Ghost Chicken" then
            SetProp(chicken, "m_nBody", 2)
            
        elseif outfit == "Festive Chicken" then
            SetProp(chicken, "m_nBody", 3)
            
        elseif outfit == "Easter Chicken" then
            SetProp(chicken, "m_nBody", 4)
            
        elseif outfit == "Jack-o'-Chicken" then
            SetProp(chicken, "m_nBody", 5)
        end
    end
end)
