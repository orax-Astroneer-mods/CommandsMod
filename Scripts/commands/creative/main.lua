local UEHelpers = require("UEHelpers")
local cmdHelpers = require("cmdHelpers")

local CommandName = cmdHelpers.getCurrentCommandName()
local cmdOptions = cmdHelpers.loadCommandOptions(CommandName)

--#region Parameters functions

local __f = {}

function __f.on()
    local playerController = UEHelpers:GetPlayerController() ---@cast playerController APlayControllerInstance_C
    if playerController:IsValid() then
        local gameState = UEHelpers.GetGameStateBase()

        if gameState:IsValid() then ---@cast gameState AAstroGameState
            gameState:SetCreativeModeActive(true)
            cmdHelpers.log("Creative mode enabled.")
        end
    end
end

function __f.off()
    local playerController = UEHelpers:GetPlayerController() ---@cast playerController APlayControllerInstance_C
    if playerController:IsValid() then
        local gameState = UEHelpers.GetGameStateBase()

        if gameState:IsValid() then ---@cast gameState AAstroGameState
            gameState:SetCreativeModeActive(false)
            gameState:SetAchievementProgressionDisabledCreative(false)
            cmdHelpers.log("Creative mode disabled.")
        end
    end
end

function __f.on_with_achievement()
    local playerController = UEHelpers:GetPlayerController() ---@cast playerController APlayControllerInstance_C
    if playerController:IsValid() then
        local gameState = UEHelpers.GetGameStateBase()

        if gameState:IsValid() then ---@cast gameState AAstroGameState
            gameState:SetCreativeModeActive(true)
            gameState:SetAchievementProgressionDisabledCreative(false)
            cmdHelpers.log("Creative mode enabled. Achievements are enabled.")
        end
    end
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
    end,

    getHelp = function(...)
        return ""
    end
}

return m
