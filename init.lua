-- Uncomment to set non-default log level
-- hs.logger.defaultLogLevel = 'debug'

require("oh-my-hammerspoon")

OMH_PLUGINS = {
   "windows.manipulation",
   "apps.skype_mute",
   "mouse.locator",
   "audio.headphones_watcher",
   "misc.clipboard",
   "misc.colorpicker",
   "keyboard.menubar_indicator",
   "apps.hammerspoon_toggle_console",
   "apps.hammerspoon_install_cli",
   "apps.hammerspoon_config_reload",
}

omh_go()
