---@class CommandsMod_Command_Params__player_loc
---@field loc FVector
---@field rot FRotator

local UEHelpers = require("UEHelpers")
local serpent = require("Scripts.lib.serpent.serpent")
local func = require("Scripts.func")

local log = _G.Log
local format = string.format
local CurrentModDirectory = _G.CurrentModDirectory

local Params = {}

---@type CommandsMod_Command
local m = {
    ---@param parameters table
    ---@param outputDevice FOutputDevice?
    ---@return boolean
    execute = function(parameters, outputDevice)
        local designAstro = UEHelpers.GetPlayer() ---@cast designAstro ADesignAstro_C
        if not designAstro:IsValid() then
            return true
        end

        local loc = designAstro:K2_GetActorLocation()
        local rot = designAstro:K2_GetActorRotation()

        if #parameters == 0 then
            local msg = func.convFVectorToString(loc) .. "\n" .. func.convFRotatorToString(rot)
            print(msg)
            if outputDevice then
                outputDevice:Log(msg)
            end

            return true
        end

        if parameters[1] == "save" then
            local name = parameters[2] or "1"

            ---@type CommandsMod_Command_Params__player_loc
            local subParams = {
                loc = loc,
                rot = rot,
            }

            local params = {
                [name] = subParams,
            }
            func.writeParamsFile(params)

            return true
        end

        if parameters[1] == "load" then
            local name = parameters[2] or "1"

            local params = func.getParams()

            if params then
                local p = params[name] ---@type CommandsMod_Command_Params__player_loc?
                if p and p.loc and p.rot then
                    ---@diagnostic disable-next-line: missing-fields
                    designAstro:K2_SetActorLocationAndRotation(params[name].loc, params[name].rot, false, {}, false)
                end
            end

            return true
        end

        return true
    end,

    getHelp = function(...)
        return ""
    end
}

return m
