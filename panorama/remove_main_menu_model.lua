local js = require("access_panorama")
local show = ui.new_checkbox("Misc", "Settings", "Show main menu model")
ui.set_callback(show, function(self)
    local state = ui.get(self)
    js.eval([[
        var model = $.GetContextPanel().GetChild(0).FindChildInLayoutFile( 'JsMainmenu_Vanity' );
        model.visible = ]].. tostring(state) .. [[;
    ]])
end)
