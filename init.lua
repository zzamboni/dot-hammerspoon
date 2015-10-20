-- Uncomment to set non-default log level
-- hs.logger.defaultLogLevel = 'debug'

----------------------------------------------------------------------
-- Some useful variables
hostname = hs.host.localizedName()
logger = hs.logger.new('main')
hs_config_dir = os.getenv("HOME") .. "/.hammerspoon/"

----------------------------------------------------------------------
-- Ensure the IPC command line client is available
hs.ipc.cliInstall()

----------------------------------------------------------------------
-- Load other files
require("lib")
require("windows.manipulation")
require("apps.skype_mute")
require("apps.hammerspoon_config_reload")
require("mouse.finder")
require("audio.headphones_watcher")
require("misc.clipboard")
require("misc.colorpicker")
require("keyboard.menubar_indicator")
-- Still figuring out what I could use this for
-- require("statuslets")

----------------------------------------------------------------------
---- Misc hotkeys

-- Toggle Hammerspoon Console
hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'y', hs.toggleConsole)

---- Notify at the end when the configuration is loaded
notify("Hammerspoon", "Config loaded")
