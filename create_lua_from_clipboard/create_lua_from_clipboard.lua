local ffi = require("ffi")
package.path = package.path .. ".\\?.lua;.\\?.ljbc;.\\lib\\?.lua;.\\libs\\?.lua;.\\lib\\?.ljbc;.\\libs\\?.ljbc;"
local filesystem = require("ifilesystem")

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

ui.new_button("misc", "Lua", "Create lua from clipboard", function()
    local bufferSize = gcpbs(isystem)
    local char = ffi.new("char[?]", bufferSize)
    gcpbt(isystem, 0, char, bufferSize * ffi.sizeof("char[?]", bufferSize))
    local source = ffi.string(char)
    local filename = random_file_name(16) ..".lua"
    print("Created " .. filename)
    table.insert(created_files, filename)
    local file = filesystem.open_file(filename, "GAME", "w")
    file:write(source)
    file:close()
end)

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
 end

client.set_event_callback("console_input", function(cmd)
    if string.find(cmd, "mv ") then
        if cmd:len() > string.len("mv ") then
            local cmd = cmd:gsub("mv ", "")
            local args = cmd:split(" ")
            if #args < 2 then 
                print("usage mv <current_file_name> <new_file_name>")
                return true
            end
            local curFile = args[1] local newFile = args[2]
            mv(fs, curFile, newFile, "GAME")
        end
        return true
    elseif string.find(cmd, "ls") then
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
