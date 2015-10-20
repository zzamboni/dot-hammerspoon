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
require("windows")
require("skype")
require("config")
require("mouse")
require("audio")
require("clipboard")
require("keyboard_menubar_indicator")
require("misc")
require("colorpicker")
-- Still figuring out what I could use this for
-- require("statuslets")

----------------------------------------------------------------------
---- Misc hotkeys

-- Toggle Hammerspoon Console
hs.hotkey.bind({"cmd", "alt", "ctrl"}, 'y', hs.toggleConsole)

---- Notify at the end when the configuration is loaded
notify("Hammerspoon", "Config loaded")
