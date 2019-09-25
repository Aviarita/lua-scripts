local js = require("access_panorama")
js.eval([[
    LoadoutAPI.IsLoadoutAllowed = function() { 
        return true;
    }
]])
