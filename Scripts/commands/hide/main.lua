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
            local solarBody = playerController:GetLocalSolarBody()
            local hide = not solarBody.bHidden

            solarBody:SetActorHiddenInGame(hide)

            if #parameters >= 1 and parameters[1] == "all" then
                local astroFoliageActors = FindAllOf("AstroFoliageActor") ---@cast astroFoliageActors AAstroFoliageActor[]
                for _, astroFoliageActor in ipairs(astroFoliageActors) do
                    if astroFoliageActor:IsValid() then
                        astroFoliageActor:SetActorHiddenInGame(hide)
                    end
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
