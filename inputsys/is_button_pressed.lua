local ffi = require 'ffi'
ffi.cdef[[
    typedef unsigned char wchar_t;

    typedef bool (__thiscall *IsButtonDown_t)(void*, int);
]]
local interface_ptr = ffi.typeof('void***')

local raw_inputsystem = client.create_interface('inputsystem.dll', 'InputSystemVersion001')

-- cast the lightuserdata to a type that we can dereference
local inputsystem = ffi.cast(interface_ptr, raw_inputsystem) -- void***

-- dereference the interface pointer to get its vtable
local inputsystem_vtbl = inputsystem[0] -- void**

-- vtable is an array of functions, the 15th is IsButtonDown
local raw_IsButtonDown = inputsystem_vtbl[15] -- void*

-- cast the function pointer to a callable type
local is_button_pressed = ffi.cast('IsButtonDown_t', raw_IsButtonDown)

local button_codes = {
    KEY_0 = 1,
    KEY_1 = 2,
    KEY_2 = 3,
    KEY_3 = 4,
    KEY_4 = 5,
    KEY_5 = 6,
    KEY_6 = 7,
    KEY_7 = 8,
    KEY_8 = 9,
    KEY_9 = 10,
    KEY_A = 11,
    KEY_B = 12,
    KEY_C = 13,
    KEY_D = 14,
    KEY_E = 15,
    KEY_F = 16,
    KEY_G = 17,
    KEY_H = 18,
    KEY_I = 19,
    KEY_J = 20,
    KEY_K = 21,
    KEY_L = 22,
    KEY_M = 23,
    KEY_N = 24,
    KEY_O = 25,
    KEY_P = 26,
    KEY_Q = 27,
    KEY_R = 28,
    KEY_S = 29,
    KEY_T = 30,
    KEY_U = 31,
    KEY_V = 32,
    KEY_W = 33,
    KEY_X = 34,
    KEY_Y = 35,
    KEY_Z = 36,
    KEY_PAD_0 = 37,
    KEY_PAD_1 = 38,
    KEY_PAD_2 = 39,
    KEY_PAD_3 = 40,
    KEY_PAD_4 = 41,
    KEY_PAD_5 = 42,
    KEY_PAD_6 = 43,
    KEY_PAD_7 = 44,
    KEY_PAD_8 = 45,
    KEY_PAD_9 = 46,
    KEY_PAD_DIVIDE = 47,
    KEY_PAD_MULTIPLY = 48,
    KEY_PAD_MINUS = 49,
    KEY_PAD_PLUS = 50,
    KEY_PAD_ENTER = 51,
    KEY_PAD_DECIMAL = 52,
    KEY_LBRACKET = 53,
    KEY_RBRACKET = 54,
    KEY_SEMICOLON = 55,
    KEY_APOSTROPHE = 56,
    KEY_BACKQUOTE = 57,
    KEY_COMMA = 58,
    KEY_PERIOD = 59,
    KEY_SLASH = 60,
    KEY_BACKSLASH = 61,
    KEY_MINUS = 62,
    KEY_EQUAL = 63,
    KEY_ENTER = 64,
    KEY_SPACE = 65,
    KEY_BACKSPACE = 66,
    KEY_TAB = 67,
    KEY_CAPSLOCK = 68,
    KEY_NUMLOCK = 69,
    KEY_ESCAPE = 70,
    KEY_SCROLLLOCK = 71,
    KEY_INSERT = 72,
    KEY_DELETE = 73,
    KEY_HOME = 74,
    KEY_END = 75,
    KEY_PAGEUP = 76,
    KEY_PAGEDOWN = 77,
    KEY_BREAK = 78,
    KEY_LSHIFT = 79,
    KEY_RSHIFT = 80,
    KEY_LALT = 81,
    KEY_RALT = 82,
    KEY_LCONTROL = 83,
    KEY_RCONTROL = 84,
    KEY_LWIN = 85,
    KEY_RWIN = 86,
    KEY_APP = 87,
    KEY_UP = 88,
    KEY_LEFT = 89,
    KEY_DOWN = 90,
    KEY_RIGHT = 91,
    KEY_F1 = 92,
    KEY_F2 = 93,
    KEY_F3 = 94,
    KEY_F4 = 95,
    KEY_F5 = 96,
    KEY_F6 = 97,
    KEY_F7 = 98,
    KEY_F8 = 99,
    KEY_F9 = 100,
    KEY_F10 = 101,
    KEY_F11 = 102,
    KEY_F12 = 103,
    KEY_CAPSLOCKTOGGLE = 104,
    KEY_NUMLOCKTOGGLE = 105,
    KEY_SCROLLLOCKTOGGLE = 106,
    -- Mouse
    MOUSE_LEFT = 107,
    MOUSE_RIGHT = 108,
    MOUSE_MIDDLE = 109,
    MOUSE_4 = 110,
    MOUSE_5 = 111,
    MOUSE_WHEEL_UP = 112,		-- A fake button which is 'pressed' and 'released' when the wheel is moved up 
    MOUSE_WHEEL_DOWN = 113,	-- A fake button which is 'pressed' and 'released' when the wheel is moved down
}

local function run_command(cmd)
    if is_button_pressed(inputsystem, 36) then -- ButtonCode_t for Z
        print('Z is pressed')
    end
    return false
end
