local log = Log
local format = string.format
local f = require("func")

local m = {}

local OutputDevice ---@type FOutputDevice?

---@param t table
---@param str string
local function includes(t, str)
    for index, value in ipairs(t) do
        if value == str then
            return true
        end
    end
    return false
end

---@param paramName string
---@param params CommandsMod_Commands_Options_Params
local function isAliasOf(paramName, params)
    if params and params.aliases then
        return includes(params.aliases, paramName)
    end

    return false
end

function m.log(...)
    local msg = format(...)
    log.info(msg)

    if OutputDevice then
        OutputDevice:Log(msg)
    end
end

---@param outputDevice FOutputDevice?
function m.setLogOutputDevice(outputDevice)
    OutputDevice = outputDevice
end

---@param __f function[]
---@param cmdOptions CommandsMod_Commands_Options
---@param parameters table
---@param outputDevice FOutputDevice?
---@return boolean
function m.execute(__f, cmdOptions, parameters, outputDevice)
    OutputDevice = outputDevice

    -- Execute the function if it exists with the name `param`.
    local param = parameters[1]
    if type(__f[param]) == "function" then
        __f[param](parameters)
        return true
    end

    -- The function was not found with this name,
    -- try to find if the name is an alias.
    for mainParamName, params in pairs(cmdOptions.params) do
        if isAliasOf(param, params) then
            if type(__f[mainParamName]) == "function" then
                -- This is an alias. Execute the corresponding function.
                __f[mainParamName](parameters)
                return true
            else
                log.warn("Function %q is not implemented.", param)
                return false
            end
        end
    end

    m.log("Unknown parameter: %q.", param)

    return false
end

function m.getCurrentCommandName()
    return debug.getinfo(2, "S").source:gsub("\\", "/"):match("@?.+/([^/]+)/")
end

---Load options file for the current command.
---@return CommandsMod_Commands_Options
---@return any
function m.loadCommandOptions(commandName)
    local commandDirectory = format([[%s\Scripts\commands\%s]], _G.CurrentModDirectory, commandName)
    local file = format([[%s\options.lua]], commandDirectory)

    if not f.isFileExists(file) then
        local cmd = format([[copy "%s\options.example.lua" "%s\options.lua"]],
            commandDirectory,
            commandDirectory)

        print("Copy options.example.lua to options.lua. Execute command: " .. cmd .. "\n")

        os.execute(cmd)
    end

    return dofile(file)
end

function m.getCommandHelp(commandName)
    local commandDirectory = format([[%s\commands\%s]], _G.CurrentModDirectory)
end

return m
