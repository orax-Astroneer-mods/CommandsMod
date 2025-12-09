local UEHelpers = require("UEHelpers")
local cmdHelpers = require("cmdHelpers")

---@type CommandsMod_Command
local m = {
    ---@param parameters table
    ---@param outputDevice FOutputDevice?
    ---@return boolean
    execute = function(parameters, outputDevice)
        cmdHelpers.setLogOutputDevice(outputDevice)

        local playerController = UEHelpers:GetPlayerController() ---@cast playerController APlayControllerInstance_C
        if playerController:IsValid() then
            local gameState = UEHelpers.GetGameStateBase()

            if gameState:IsValid() then ---@cast gameState AAstroGameState
                gameState:SetCreativeModeActive(true)

                -- save the values ​​of the creative mode
                ---@type CommandsMod_Shared__AstroGameState
                _G.SHARED.AstroGameState = {
                    IsCatalogUnlockedCreative = gameState:IsCatalogUnlockedCreative(),
                    IsOxygenFreeCreative = gameState:IsOxygenFreeCreative(),
                    IsInvincibleCreative = gameState:IsInvincibleCreative(),
                    IsBackpackPowerUnlimitedCreative = gameState:IsBackpackPowerUnlimitedCreative(),
                    IsInvisibleToHazardsCreative = gameState:IsInvisibleToHazardsCreative(),
                    IsFuelFreeCreative = gameState:IsFuelFreeCreative(),
                }
                ---@type CommandsMod_Shared__PlayController
                _G.SHARED.PlayController = {
                    IsCreativeCollectResourcesWhileDeformingDisabled = playerController
                        :IsCreativeCollectResourcesWhileDeformingDisabled()
                }

                gameState:SetCatalogUnlockedCreative(false)
                gameState:SetOxygenFreeCreative(false)
                gameState:SetInvincibleCreative(false)
                gameState:SetBackpackPowerUnlimitedCreative(false)
                gameState:SetInvisibleToHazardsCreative(false)
                gameState:SetFuelFreeCreative(false)

                gameState:SetAchievementProgressionDisabledCreative(false)

                playerController:SetCreativeCollectResourcesWhileDeformingDisabled(false)

                cmdHelpers.log(
                "Fly mode enabled. Open the Creative Mode menu to change the flight speed. Enter the command \"walk\" to disable this mode.")
            end
        end

        return true
    end,

    getHelp = function(...)
        return ""
    end
}

return m
