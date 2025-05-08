local log = Log
local format = string.format
local UEHelpers = require("UEHelpers")
local cmdHelpers = require("cmdHelpers")

local cmdSharedOptions = _G.SHARED_CMD_OPTIONS

local CommandName = cmdHelpers.getCurrentCommandName()
local cmdOptions, extraOptions = cmdHelpers.loadCommandOptions(CommandName)
---@cast extraOptions CommandsMod_Commands_Options_Extra__saves

local function getSaveName()
    local saveGames = extraOptions.directory .. "\\" .. extraOptions.filter
    local handle = io.popen(string.format('dir "%s" /B /O:-D', saveGames))
    if handle then
        local fileName = handle:lines()() ---@type string
        handle:close()
        return fileName:gsub([[%.[^%.]+$]], "")
    end
end

--#region Parameters functions

local __f = {}

function __f.open_SaveGames_directory()
    local handle = io.popen(string.format('explorer "%s"', extraOptions.directory))
    if handle then
        handle:close()
    end
end

---@return string?
function __f.load_latest_save()
    local astroStatics = StaticFindObject("/Script/Astro.Default__AstroStatics")
    assert(astroStatics:IsValid()) ---@cast astroStatics UAstroStatics

    local saveName = getSaveName()
    if saveName ~= "" then
        ---@diagnostic disable-next-line: param-type-mismatch
        astroStatics:LoadGame(saveName, UEHelpers.GetWorld())

        return saveName
    end
end

function __f.get_save_name()
    cmdHelpers.log(format("Current save name: %q.", getSaveName()))
end

--#endregion

---@type CommandsMod_Command
local m = {
    ---@param parameters table
    ---@param outputDevice FOutputDevice?
    ---@return boolean
    execute = function(parameters, outputDevice)
        if #parameters == 0 then
            return true
        end

        return cmdHelpers.execute(__f, cmdOptions, parameters, outputDevice)
    end
}

return m
