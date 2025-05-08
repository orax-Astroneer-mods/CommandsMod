local log = Log
local UEHelpers = require("UEHelpers")

---@type CommandsMod_Command
local m = {
    ---@param parameters table
    ---@param outputDevice FOutputDevice?
    ---@return boolean
    execute = function(parameters, outputDevice)
        local gameplayStatics = UEHelpers.GetGameplayStatics()
        local world = UEHelpers.GetWorld()

        local limit = tonumber(parameters[1])

        local isPaused = not gameplayStatics:IsGamePaused(world)

        gameplayStatics:SetGamePaused(world, isPaused)
        print("Game paused: " .. tostring(isPaused) .. ".")

        local AstroGameUserSettings = FindFirstOf("AstroGameUserSettings")
        if AstroGameUserSettings:IsValid() then ---@cast AstroGameUserSettings UAstroGameUserSettings
            if FpsLimit == nil then
                FpsLimit = AstroGameUserSettings:GetFpsLimit()
            end
            if FrameRateLimit == nil then
                FrameRateLimit = AstroGameUserSettings:GetFrameRateLimit()
            end

            if limit then
                if isPaused then
                    AstroGameUserSettings:SetFpsLimit(limit)
                    AstroGameUserSettings:SetFrameRateLimit(limit)
                    AstroGameUserSettings:ApplySettings(false)
                else
                    AstroGameUserSettings:SetFpsLimit(FpsLimit)
                    AstroGameUserSettings:SetFrameRateLimit(FrameRateLimit)
                    AstroGameUserSettings:ApplySettings(false)
                end
            end
        end

        return true
    end
}

return m
