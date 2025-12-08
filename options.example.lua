-- Log levels: ALL, TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF.
LOG_LEVEL = "INFO" ---@type _LogLevel
MIN_LEVEL_OF_FATAL_ERROR = "ERROR" ---@type _LogLevel

---@type CommandsMod_Options
return {
  helpFileLng = "en",

  -- Register only one main command. The other commands will be subcommands of the main command.
  -- This can be useful when you have many registered commands with other mods, to avoid conflicts.
  -- Example with a `hide` command and with `mainCommand = { "cmd", "c" }`:
  -- With `registerMainCommand = true`, the command to type is:
  --   cmd hide
  -- or
  --   c hide
  -- With `registerMainCommand = false`, the command to type is:
  --   hide
  registerMainCommand = false, -- true | false
  mainCommand = { "cmd", "c" },

  commands = {

    -- command name
    enable_move = {

      -- true | false (default: true)
      load = true,

      -- true | false (default: true)
      register = true,

      -- You can define aliases for each command.
      -- Example with `aliases = { "enable_move", "enablemv", "move_on" }`:
      -- The commands `enable_move`, `enablemv` and `move_on` wil do the same thing.
      aliases = { "enable_move", "enablemv", "move_on" },
    },

    hide = {
      aliases = { "hide", "h" },
      keybinds = {
        {
          register = true,
          parameters = {},
          key = Key.H,
          modifierKeys = { ModifierKey.CONTROL }
        },
        {
          register = true,
          parameters = { "all" },
          key = Key.H,
          modifierKeys = { ModifierKey.CONTROL, ModifierKey.SHIFT }
        }
      }
    },

    pause = {
      keybinds = {
        {
          key = Key.PAUSE,
        },
        {
          -- Pause and set an FPS/framerate limit to 1. This will reduce CPU/GPU load.
          parameters = { 1 },
          key = Key.PAUSE,
          modifierKeys = { ModifierKey.SHIFT }
        }
      }
    },

    quit = {
      aliases = { "qq" }
    },

    quit_game = {
      aliases = { "qg" }
    },
    creative = {
    }
  }
}
