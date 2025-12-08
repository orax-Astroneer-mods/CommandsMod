local log = Log
local UEHelpers = require("UEHelpers")

---@type CommandsMod_Command
local m = {
    ---@param parameters table
    ---@param outputDevice FOutputDevice?
    ---@return boolean
    execute = function(parameters, outputDevice)
        local playerController = UEHelpers:GetPlayerController() ---@cast playerController APlayControllerInstance_C
        if playerController:IsValid() then
            local gameState = UEHelpers.GetGameStateBase()

            if gameState:IsValid() then ---@cast gameState AAstroGameState
                if #parameters == 1 and parameters[1] == "on" then
                    gameState:SetCreativeModeActive(true)
                end
                if #parameters == 1 and parameters[1] == "off" then
                    gameState:SetCreativeModeActive(false)
                    gameState:SetAchievementProgressionDisabledCreative(false)
                end
            end
        end

        return true
    end,

    getHelp = function(...)
        return ""
    end
}

return m
