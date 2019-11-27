local ffi = require("ffi")
package.path = package.path .. ".\\?.lua;.\\?.ljbc;.\\lib\\?.lua;.\\libs\\?.lua;.\\lib\\?.ljbc;.\\libs\\?.ljbc;"
local filesystem = require("filesystem")

ffi.cdef[[
    typedef void(__thiscall* asp_t)(void*, const char*, const char*, int);
    typedef bool(__thiscall* rsp_t)(void*, const char*, const char*);
    typedef int(__thiscall* gcpbs_t)(void*);
    typedef int(__thiscall* gcpbt_t)(void*, int,  char*, int);
    typedef char(__thiscall* gcd_t)(void*, char*, int);
    typedef bool(__thiscall* mv_t)(void*, const char*, const char*, const char*);
]] 

local fs = ffi.cast(ffi.typeof("void***"), client.create_interface("filesystem_stdio.dll", "VFileSystem017"))
local asp = ffi.cast("asp_t", client.find_signature("filesystem_stdio.dll", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x56\x57"))
local rsp = ffi.cast("rsp_t", client.find_signature("filesystem_stdio.dll", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x8B"))
local gcd = ffi.cast("gcd_t", client.find_signature("filesystem_stdio.dll", "\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF"))
local mv = ffi.cast("mv_t", client.find_signature("filesystem_stdio.dll", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x10"))

local isystem = ffi.cast(ffi.typeof("void***"), client.create_interface("vgui2.dll", "VGUI_System010"))
local gcpbs = ffi.cast("gcpbs_t", isystem[0][7])
local gcpbt = ffi.cast("gcpbt_t", isystem[0][11])

local function random_file_name(len)
    local res, len = "", len or 32
    for i=1, len do
        res = res .. string.char(client.random_int(97, 122))
    end
    return res
end

local p = ffi.new("char[260]")
gcd(fs, p, ffi.sizeof(p))
asp(fs, p, "GAME", 0)

local created_files = {}

local filename = nil
local randomize_filename = ui.new_checkbox("config", "lua", "Randomize file name")
ui.new_button("config", "Lua", "Create lua from clipboard", function()
    local fileName = ui.get(randomize_filename) and random_file_name(16) or ui.get(filename)
    if fileName:len() < 1 then 
        error("you need to enter a file name")
    end
    if fileName:find(".lua") then 
        fileName = fileName:gsub(".lua", "")
    end
    fileName = fileName .. ".lua"

    local bufferSize = gcpbs(isystem)
    local char = ffi.new("char[?]", bufferSize)
    gcpbt(isystem, 0, char, bufferSize * ffi.sizeof("char[?]", bufferSize))
    local source = ffi.string(char)
    print("Created " .. fileName)
    table.insert(created_files, fileName)
    local file = filesystem.open_file(fileName, "GAME", "w")
    file:write(source)
    file:close()
end)
filename = ui.new_textbox("config", "lua", "Create lua from clipboard")

ui.set_callback(randomize_filename, function(self)
    ui.set_visible(filename, not ui.get(self))
end)
ui.set_visible(filename, ui.get(randomize_filename))

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
 end

client.set_event_callback("console_input", function(cmd)
    local tmpCmd = string.sub(cmd, 1, 3) 
    if tmpCmd == "mv " then
        if cmd:len() > string.len("mv ") then
            local cmd = cmd:gsub("mv ", "")
            local args = cmd:split(" ")
            if #args < 2 then 
                print("usage mv <current_file_name> <new_file_name>")
                return true
            end
            local curFile = args[1] local newFile = args[2]
            if mv(fs, curFile, newFile, "GAME") then 
                print("successfully renamed " .. curFile .. " to " .. newFile)
            else
                error("something wen't wrong when trying to rename the lua, please check the entered arguments.")
            end
            
        end
        return true
    elseif tmpCmd == "ls" then
        if #created_files < 1 then 
            print("you haven't created any files yet.")
            return true
        end
        for i=1, #created_files do 
            print(created_files[i])
        end
        return true
    end
end)

client.set_event_callback("shutdown", function(cmd)
    rsp(fs, p, "GAME")
end)
