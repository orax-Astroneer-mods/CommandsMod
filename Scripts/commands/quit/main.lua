local log = Log
local UEHelpers = require("UEHelpers")

---@param returnToTitleScreen boolean
local function quitGame(returnToTitleScreen)
    local AstroGameMenuStatics = StaticFindObject("/Script/Astro.Default__AstroGameMenuStatics")
    assert(AstroGameMenuStatics:IsValid()) ---@cast AstroGameMenuStatics UAstroGameMenuStatics
    AstroGameMenuStatics:GameMenuForceQuitGame(UEHelpers:GetWorld(), returnToTitleScreen, false, false)
end

---@type CommandsMod_Command
local m = {
    ---@param parameters table
    ---@param outputDevice FOutputDevice?
    ---@return boolean
    execute = function(parameters, outputDevice)
        local msg = "Quit without saving. Return to title screen."
        log.info(msg)
        if outputDevice then
            outputDevice:Log(msg)
        end

        quitGame(true)
        return true
    end
}

return m
