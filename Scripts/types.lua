---@meta _

---@class CommandsMod_Options
---@field registerMainCommand boolean
---@field mainCommand string[]
---@field commands table<string, CommandsMod_Main_Commands_Options>

---@class CommandsMod_Main_Commands_Options
---@field load boolean?
---@field register boolean?
---@field aliases string[]?
---@field keybinds CommandsMod_Options_Keybinds[]?

---@class CommandsMod_Shared_Commands_Options Options file that can be shared with all commands.

---@class CommandsMod_Commands_Options
---@field params table<string, CommandsMod_Commands_Options_Params>

---@class CommandsMod_Commands_Options_Params
---@field aliases? string[]

---@class CommandsMod_Command
---@field execute fun(parameters: table, outputDevice: FOutputDevice?): boolean
---@field getHelp? fun(...): string

---@class CommandsMod_Options_Keybinds
---@field register boolean?
---@field parameters table?
---@field key Key
---@field modifierKeys ModifierKey[]?

--------------------------------------------------

---@class CommandsMod_Shared__AstroGameState
---@field IsCatalogUnlockedCreative boolean
---@field IsOxygenFreeCreative boolean
---@field IsInvincibleCreative boolean
---@field IsBackpackPowerUnlimitedCreative boolean
---@field IsInvisibleToHazardsCreative boolean
---@field IsFuelFreeCreative boolean

---@class CommandsMod_Shared__PlayController
---@field IsCreativeCollectResourcesWhileDeformingDisabled boolean
