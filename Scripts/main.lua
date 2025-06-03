---@class FOutputDevice
---@field Log function

local currentModDirectory = debug.getinfo(1, "S").source:match("@?(.+)\\[Ss]cripts\\")
_G.CurrentModDirectory = currentModDirectory

local Commands = {
    enable_move = { "enable_move" },
    hide_planet = { "hide_planet" }
}

local UEHelpers = require("UEHelpers")
local utils = require("lib.lua-mods-libs.utils")
local logging = require("lib.lua-mods-libs.logging")

local format = string.format

---@type EPhysicalItemMotionState
local EPhysicalItemMotionState = {
    Simulating = 0,
    PickedUp = 1,
    Slotted = 2,
    NonSimulating = 3,
    Indicator = 4,
    EPhysicalItemMotionState_MAX = 5,
}

---@param filename string
---@return boolean
local function isFileExists(filename)
    local file = io.open(filename, "r")
    if file ~= nil then
        io.close(file)
        return true
    else
        return false
    end
end

local function loadDevOptions()
    local file = format([[%s\options.dev.lua]], _G.CurrentModDirectory)

    if isFileExists(file) then
        dofile(file)
    end
end

local function loadOptions()
    local file = format([[%s\options.lua]], _G.CurrentModDirectory)

    if not isFileExists(file) then
        local cmd = format([[copy "%s\options.example.lua" "%s\options.lua"]],
            _G.CurrentModDirectory,
            _G.CurrentModDirectory)

        print("Copy options.example.lua to options.lua. Execute command: " .. cmd .. "\n")

        os.execute(cmd)
    end

    return dofile(file)
end

local function loadSharedCommandsOptions()
    local file = format([[%s\shared_cmd_options.lua]], _G.CurrentModDirectory)

    if not isFileExists(file) then
        local cmd = format([[copy "%s\shared_cmd_options.example.lua" "%s\shared_cmd_options.lua"]],
            _G.CurrentModDirectory,
            _G.CurrentModDirectory)

        print("Copy example shared_cmd_options.example.lua to shared_cmd_options.lua. Execute command: " .. cmd .. "\n")

        os.execute(cmd)
    end

    return dofile(file)
end

--------------------------------------------------------------------------------

-- Default logging levels. They can be overwritten in the options file.
LOG_LEVEL = "INFO" ---@type _LogLevel
MIN_LEVEL_OF_FATAL_ERROR = "ERROR" ---@type _LogLevel

-- load options files before loading commands files
local options = loadOptions() ---@type CommandsMod_Options
_G.OPTIONS = options
loadDevOptions()
local SharedCmdOptions = loadSharedCommandsOptions() ---@type CommandsMod_Shared_Commands_Options
_G.SHARED_CMD_OPTIONS = SharedCmdOptions

Log = logging.new(LOG_LEVEL, MIN_LEVEL_OF_FATAL_ERROR)
local log = Log
LOG_LEVEL, MIN_LEVEL_OF_FATAL_ERROR = nil, nil

--------------------------------------------------------------------------------

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

---@return table<string, CommandsMod_Command>
local function loadCommands()
    local cmdDir = format([[%s\Scripts\commands]], _G.CurrentModDirectory)
    local fileList = utils.getFileList(cmdDir, "main%.lua$") ---@type string[]
    local commands = {}

    for index, file in ipairs(fileList) do
        local commandName = file:match("\\([^\\]+)\\main%.lua$")
        local commandOptions = options.commands[commandName]

        if commandOptions == nil then
            local commandFunction = dofile(file)
            commands[commandName] = commandFunction
        else
            if commandOptions.load == nil or commandOptions.load == true then
                local commandObject = dofile(file)

                if type(commandOptions.aliases) == "table" and #commandOptions.aliases > 0 then
                    for _, alias in ipairs(commandOptions.aliases) do
                        commands[alias] = commandObject
                    end
                else
                    commands[commandName] = commandObject
                end
            end
        end
    end

    return commands
end

Commands = loadCommands()

---@param outputDevice FOutputDevice
local function showHelp(outputDevice)

end

---@param fullCommand string
---@param parameters table
---@param outputDevice FOutputDevice
---@return boolean
local function mainCallback(fullCommand, parameters, outputDevice)
    if #parameters == 0 then
        showHelp(outputDevice)
        return true
    end

    local commandObject = Commands[parameters[1]]

    if type(commandObject) == "table" then
        table.remove(parameters, 1)
        -- execute the command function with parameters if any
        return commandObject.execute(parameters, outputDevice)
    end

    return false
end

-- Register a single main command or each command individually.
if options.registerMainCommand == true then
    -- single main command
    for _, name in ipairs(options.mainCommand) do
        RegisterConsoleCommandHandler(name, mainCallback)
    end
else
    -- register each command individually
    for name, command in pairs(Commands) do
        local commandOptions = options.commands[name]

        if commandOptions == nil or commandOptions.register == nil or commandOptions.register == true then
            RegisterConsoleCommandHandler(name,
                ---@param fullCommand string
                ---@param parameters table
                ---@param outputDevice FOutputDevice
                ---@return boolean
                function(fullCommand, parameters, outputDevice)
                    return command.execute(parameters, outputDevice)
                end)
        end
    end
end

-- register keybinds
for name, cmdOpt in pairs(options.commands) do
    if cmdOpt.keybinds then
        for _, keybind in ipairs(cmdOpt.keybinds) do
            if keybind.register == nil or keybind.register == true then
                if type(keybind.modifierKeys) == "table" then
                    RegisterKeyBind(keybind.key, keybind.modifierKeys, function()
                        Commands[name].execute(keybind.parameters or {}, nil)
                    end)
                else
                    RegisterKeyBind(keybind.key, function()
                        Commands[name].execute(keybind.parameters or {}, nil)
                    end)
                end
            end
        end
    end
end
