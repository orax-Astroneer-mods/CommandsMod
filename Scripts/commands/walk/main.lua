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
                -- restore the values ​​of the creative mode
                if type(_G.SHARED.AstroGameState) == "table" then
                    if type(_G.SHARED.AstroGameState.IsCatalogUnlockedCreative) == "boolean" then
                        gameState:SetCatalogUnlockedCreative(_G.SHARED.AstroGameState.IsCatalogUnlockedCreative)
                    end
                    if type(_G.SHARED.AstroGameState.IsOxygenFreeCreative) == "boolean" then
                        gameState:SetOxygenFreeCreative(_G.SHARED.AstroGameState.IsOxygenFreeCreative)
                    end
                    if type(_G.SHARED.AstroGameState.IsInvincibleCreative) == "boolean" then
                        gameState:SetInvincibleCreative(_G.SHARED.AstroGameState.IsInvincibleCreative)
                    end
                    if type(_G.SHARED.AstroGameState.IsBackpackPowerUnlimitedCreative) == "boolean" then
                        gameState:SetBackpackPowerUnlimitedCreative(_G.SHARED.AstroGameState
                            .IsBackpackPowerUnlimitedCreative)
                    end
                    if type(_G.SHARED.AstroGameState.IsInvisibleToHazardsCreative) == "boolean" then
                        gameState:SetInvisibleToHazardsCreative(_G.SHARED.AstroGameState.IsInvisibleToHazardsCreative)
                    end
                    if type(_G.SHARED.AstroGameState.IsFuelFreeCreative) == "boolean" then
                        gameState:SetFuelFreeCreative(_G.SHARED.AstroGameState.IsFuelFreeCreative)
                    end
                end

                if type(_G.SHARED.PlayController) == "table" then
                    if type(_G.SHARED.PlayController.IsCreativeCollectResourcesWhileDeformingDisabled) == "boolean" then
                        playerController:SetCreativeCollectResourcesWhileDeformingDisabled(_G.SHARED.PlayController
                            .IsCreativeCollectResourcesWhileDeformingDisabled)
                    end
                end

                gameState:SetCreativeModeActive(false)
                gameState:SetAchievementProgressionDisabledCreative(false)

                cmdHelpers.log("Walk mode enabled.")
            end
        end

        return true
    end,

    getHelp = function(...)
        return ""
    end
}

return m
