local js = require("access_panorama")
local show = ui.new_checkbox("Misc", "Settings", "Remove main menu model")
ui.set_callback(show, function(self)
    local state = ui.get(self)
    js.eval([[
        var model = $.GetContextPanel().GetChild(0).FindChildInLayoutFile( 'JsMainmenu_Vanity' );
        elModel.visible = ]].. state .. [[;
    ]])
end)