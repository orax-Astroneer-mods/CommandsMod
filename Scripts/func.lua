local cmdOptions = _G.SHARED_CMD_OPTIONS ---@cast cmdOptions CommandsMod_Shared_Commands_Options
local log = _G.Log
local format = string.format
local sqrt = math.sqrt

local UEHelpers = require("UEHelpers")
local serpent = require("lib.serpent.serpent")

local CurrentModDirectory = _G.CurrentModDirectory
local ParamsFileName = "params.lua"
local ScriptName = nil

local m = {}

local function getScriptName()
    local scriptName = ScriptName or debug.getinfo(4, "S").source:gsub("\\", "/"):match("@?/([^/]+)/main%.lua$")
    ScriptName = scriptName
    return scriptName
end

---@param t1 table
---@param t2 table
---@return table
function m.mergeTables(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end

    return t1
end

--- Get the length of a vector.
---@param u FVector
---@return number len
function m.getVectorLen(u)
    return sqrt(u.X * u.X + u.Y * u.Y + u.Z * u.Z)
end

---@param v FVector
---@return string
function m.convFVectorToString(v)
    return format("X=%.17g, Y=%.17g, Z=%.17g", v.X, v.Y, v.Z)
end

---@param r FRotator
---@return string
function m.convFRotatorToString(r)
    return format("Pitch=%.17g, Yaw=%.17g, Roll=%.17g", r.Pitch, r.Yaw, r.Roll)
end

---@param filename string
---@return string
function m.readFile(filename)
    local content = ""
    local file = io.open(filename, "r")

    if file ~= nil then
        content = file:read("a")
        file:close()
    end

    return content
end

---@param filename string
---@return boolean
function m.isFileExists(filename)
    local file = io.open(filename, "r")
    if file ~= nil then
        io.close(file)
        return true
    else
        return false
    end
end

---@return string
function m.getParamsFile()
    return format([[%s\Scripts\commands\%s\params.lua]], CurrentModDirectory, getScriptName())
end

---@param file string?
---@return table
function m.getParams(file)
    local ret = {}
    file = file or m.getParamsFile()

    if m.isFileExists(file) then
        local f, err = load(m.readFile(file))
        if f == nil then error(err) end

        ret = f()
    end

    return type(ret) == "table" and ret or {}
end

---@param scriptParams table
function m.writeParamsFile(scriptParams)
    log.debug("Write params file.")

    local file = m.getParamsFile()

    local params = m.getParams(file)
    if type(params) ~= "table" then
        params = {}
    end

    local fileHandle = io.open(file, "w+")
    assert(fileHandle, format("\nUnable to open the params file %q.", file))

    params = m.mergeTables(params, scriptParams)

    fileHandle:write('return ' .. serpent.block(params, { comment = false }))
    fileHandle:close()
end

return m
