local ffi = require("ffi")
ffi.cdef[[
    // UIEngine
    typedef void*(__thiscall* access_ui_engine_t)(void*, void); // 11
    typedef bool(__thiscall* is_valid_panel_ptr_t)(void*, void*); // 36
    typedef void*(__thiscall* get_last_target_panel_t)(void*); // 56
    typedef int (__thiscall *run_script_t)(void*, void*, char const*, char const*, int, int, bool, bool); // 113

    // IUIPanel
    typedef const char*(__thiscall* get_panel_id_t)(void*, void); // 9
    typedef void*(__thiscall* get_parent_t)(void*); // 25
    typedef void*(__thiscall* set_visible_t)(void*, bool); // 27
]]
local interface_ptr = ffi.typeof("void***")
local rawpanoramaengine = client.create_interface("panorama.dll", "PanoramaUIEngine001")
local panoramaengine = ffi.cast(interface_ptr, rawpanoramaengine) -- void***
local panoramaengine_vtbl = panoramaengine[0] -- void**

local access_ui_engine = ffi.cast("access_ui_engine_t", panoramaengine_vtbl[11]) -- void*

local function get_last_target_panel(uiengineptr)
    local a_get_last_target_panel = ffi.cast("get_last_target_panel_t", uiengineptr[0][56])
    return a_get_last_target_panel(uiengineptr)
end

local function is_valid_panel_ptr(uiengineptr, itr)
    local a_is_valid_panel_ptr = ffi.cast("is_valid_panel_ptr_t", uiengineptr[0][36])
    return a_is_valid_panel_ptr(uiengineptr, itr)
end

local function get_panel_id(panelptr)
    local a_get_panel_id = ffi.cast("get_panel_id_t", panelptr[0][9])
    return ffi.string(a_get_panel_id(panelptr))
end

local function set_visible(panelptr, state)
    local a_set_visible = ffi.cast("set_visible_t", panelptr[0][27])
    a_set_visible(panelptr, state)
end

local function get_parent(panelptr)
    local a_get_parent = ffi.cast("get_parent_t", panelptr[0][25])
    return a_get_parent(panelptr)
end

local function get_root(uiengineptr, custompanel)
    local panel = get_last_target_panel(uiengineptr)
    local itr = panel
    local ret = nil
    local panelptr = ffi.cast("void***", itr)
    while itr and is_valid_panel_ptr(uiengineptr, itr) do 
        panelptr = ffi.cast("void***", itr)
        if custompanel and get_panel_id(panelptr) == custompanel then 
            ret = itr
            break
        elseif get_panel_id(panelptr) == "CSGOHud" then 
            ret = itr
            break
        elseif get_panel_id(panelptr) == "CSGOMainMenu" then 
            ret = itr
            break
        end
        itr = get_parent(panelptr)
    end
    return ret
end

local uiengine = ffi.cast("void***", access_ui_engine(panoramaengine))
local run_script = ffi.cast("run_script_t", uiengine[0][113])

local rootpanel = get_root(uiengine)

local function eval(code, custompanel)
    if custompanel then 
        rootpanel = custompanel
    else
        if rootpanel == nil then    
            rootpanel = get_root(uiengine)
        end
    end
    run_script(uiengine, rootpanel, ffi.string(code), "panorama/layout/base_mainmenu.xml", 8, 10, false, false)
end
local function get_child(childname)
    return get_root(uiengine, childname)
end
local function change_visiblity(childptr, state)
    local panelptr = ffi.cast("void***", childptr)
    if is_valid_panel_ptr(uiengine, childptr) then 
        return set_visible(panelptr, state)
    else
        error("Invalid panel..", 2)
    end
end
local function get_child_name(childptr)
    local panelptr = ffi.cast("void***", childptr)
    if is_valid_panel_ptr(uiengine, childptr) then 
        return ffi.string(get_panel_id(panelptr))
    else
        error("Invalid panel..", 2)
    end
end
return {
    eval = eval,
    get_child = get_child,
    get_child_name = get_child_name,
    set_visible = change_visiblity
}
