require("oh-my-hammerspoon")

hyper = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}
local col = hs.drawing.color.x11

----------------------------------------------------------------------

hs.loadSpoon("SpoonUtils")

----------------------------------------------------------------------

hs.loadSpoon("MouseCircle")

spoon.MouseCircle.color=hs.drawing.color.x11.rebeccapurple
spoon.MouseCircle:bindHotkeys({
      show = { hyper, "D" }
})

----------------------------------------------------------------------

hs.loadSpoon("BrewInfo")

spoon.BrewInfo:bindHotkeys({
      show_brew_info = {hyper, "b"},
      open_brew_url = {shift_hyper, "b"},
})
spoon.BrewInfo.brew_info_style = {
   textFont = "Inconsolata",
   textSize = 14,
   radius = 10,
}

----------------------------------------------------------------------

hs.loadSpoon("Hammer")

spoon.Hammer:bindHotkeys({
      config_reload = {hyper, "r"},
      toggle_console = {hyper, "y"}
})
spoon.Hammer:start()

----------------------------------------------------------------------

hs.loadSpoon("URLDispatcher")

spoon.URLDispatcher.url_patterns = {
   { "https?://issue.swisscom.ch", "org.epichrome.app.SwisscomJira" },
   { "https?://issue.swisscom.com", "org.epichrome.app.SwisscomJira" },
   { "https?://jira.swisscom.com", "org.epichrome.app.SwisscomJira" },
   { "https?://wiki.swisscom.com", "org.epichrome.app.SwisscomWiki" },
   { "https?://collaboration.swisscom.com", "org.epichrome.app.SwisscomCollab" },
   { "https?://smca.swisscom.com", "org.epichrome.app.SwisscomTWP" },
   { "https?://portal.corproot.net", "com.apple.Safari" },
}
spoon.URLDispatcher.default_handler = "com.google.Chrome"
spoon.URLDispatcher:start()

----------------------------------------------------------------------

hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

----------------------------------------------------------------------

hs.loadSpoon("MenubarFlag")
spoon.MenubarFlag.colors = {
   ["U.S."] = { },
   Spanish = {col.green, col.white, col.red},
   German = {col.black, col.red, col.yellow},
}
spoon.MenubarFlag.logger.setLogLevel('debug')
spoon.MenubarFlag:start()

----------------------------------------------------------------------

hs.loadSpoon("WindowManipulation")
spoon.WindowManipulation:bindHotkeys(spoon.WindowManipulation.defaultHotkeys)
spoon.WindowManipulation.use_frame_correctness = true

----------------------------------------------------------------------

hs.loadSpoon("WindowGrid")
spoon.WindowGrid:bindHotkeys({show_grid = {hyper, "g"}})
spoon.WindowGrid.gridGeometries = { { "6x4" } }
spoon.WindowGrid:start()

----------------------------------------------------------------------

hs.loadSpoon("ToggleScreenRotation")
spoon.ToggleScreenRotation:bindHotkeys({first = {hyper, "f15"}})

----------------------------------------------------------------------

hs.loadSpoon("UniversalArchive")
spoon.UniversalArchive.evernote_archive_notebook = ".Archive"
spoon.UniversalArchive.outlook_archive_folder = "Archive (On My Computer)"
spoon.UniversalArchive:bindHotkeys({
      archive = { { "ctrl", "cmd" }, "a" }, 
})
spoon.UniversalArchive.archive_notifications = false

----------------------------------------------------------------------

hs.loadSpoon("SendToOmniFocus")
spoon.SendToOmniFocus:bindHotkeys({
      send_to_omnifocus = { hyper, "t" }
})
spoon.SendToOmniFocus:registerApplication("Swisscom Collab", { apptype = "chromeapp", itemname = "tab" })
spoon.SendToOmniFocus:registerApplication("Swisscom Wiki", { apptype = "chromeapp", itemname = "wiki page" })
spoon.SendToOmniFocus:registerApplication("Swisscom Jira", { apptype = "chromeapp", itemname = "issue" })
spoon.SendToOmniFocus.quickentrydialog = false
spoon.SendToOmniFocus.notifications = true
--spoon.SendToOmniFocus.logger.setLogLevel("debug")

----------------------------------------------------------------------

-- function plainInputSourceChange()
--    hs.alert.show("Input source change detected! new layout=" .. hs.keycodes.currentLayout())
-- end
-- hs.keycodes.inputSourceChanged(plainInputSourceChange)

omh.go({
      --      "omh.config_reload",
      --      "apps.hammerspoon_toggle_console",
      --      "apps.hammerspoon_install_cli",
      --      "windows.manipulation",
      --      "windows.grid",
      "apps.skype_mute",
      --      "mouse.locator",
      "audio.headphones_watcher",
      "misc.clipboard",
      "misc.colorpicker",
      --      "keyboard.menubar_indicator",
      --      "apps.universal_archive",
      --      "apps.universal_omnifocus",
      --      "windows.screen_rotate",
      "apps.evernote",
      --      "misc.url_handling",
      --      "omh.brew_info",
      --      "misc.presentation",
})
