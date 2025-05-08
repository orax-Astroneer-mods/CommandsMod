---@type CommandsMod_Commands_Options
local opt = {
    params = {
        load_latest_save = {
            aliases = { "load", "-l" }
        },
        get_save_name = {
            aliases = {}
        },
        backup = {
            aliases = { "-b" }
        },
    }
}

---@class CommandsMod_Commands_Options_Extra__saves
local extra = {
    directory = [[%LocalAppData%\Astro\Saved\SaveGames]],
    filter = "*.savegame",
    extension = "savegame",
    backup_string = "BACKUP_",
}

return opt, extra
