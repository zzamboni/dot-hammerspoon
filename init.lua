hs.logger.defaultLogLevel="info"

require("oh-my-hammerspoon")

hyper = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}
local col = hs.drawing.color.x11

hs.spoons.repos.zzspoons = {
   url = "https://github.com/zzamboni/zzSpoons",
   desc = "zzamboni's spoon repository",
}

hs.loadSpoon("UseSpoon")

----------------------------------------------------------------------

spoon.UseSpoon("MouseCircle",
               {
                  config = {
                     color = hs.drawing.color.x11.rebeccapurple
                  },
                  hotkeys = {
                     show = { hyper, "D" }
                  }
               }
)

----------------------------------------------------------------------

spoon.UseSpoon("BrewInfo",
               {
                  config = {
                     brew_info_style = {
                        textFont = "Inconsolata",
                        textSize = 14,
                        radius = 10 }
                  },
                  hotkeys = {
                     show_brew_info = {hyper, "b"},
                     open_brew_url = {shift_hyper, "b"},
                  }
               }
)

----------------------------------------------------------------------

spoon.UseSpoon("URLDispatcher",
               {
                  config = {
                     url_patterns = {
                        { "https?://issue.swisscom.ch", "org.epichrome.app.SwisscomJira" },
                        { "https?://issue.swisscom.com", "org.epichrome.app.SwisscomJira" },
                        { "https?://jira.swisscom.com", "org.epichrome.app.SwisscomJira" },
                        { "https?://wiki.swisscom.com", "org.epichrome.app.SwisscomWiki" },
                        { "https?://collaboration.swisscom.com", "org.epichrome.app.SwisscomCollab" },
                        { "https?://smca.swisscom.com", "org.epichrome.app.SwisscomTWP" },
                        { "https?://portal.corproot.net", "com.apple.Safari" },
                     },
                     default_handler = "com.google.Chrome"
                  },
                  start = true
               }
)

----------------------------------------------------------------------

spoon.UseSpoon("Caffeine")

----------------------------------------------------------------------

spoon.UseSpoon("MenubarFlag",
               {
                  config = {
                     colors = {
                        ["U.S."] = { },
                        Spanish = {col.green, col.white, col.red},
                        German = {col.black, col.red, col.yellow},
                     }
                  },
                  start = true
               }
)

----------------------------------------------------------------------

spoon.UseSpoon("WindowHalfsAndThirds",
               {
                  repo = 'zzspoons',
                  config = {
                     use_frame_correctness = true
                  },
                  hotkeys = 'default'
               }
)

----------------------------------------------------------------------

spoon.UseSpoon("WindowScreenLeftAndRight",
               {
                  repo = 'zzspoons',
                  hotkeys = 'default'
               }
)

----------------------------------------------------------------------

spoon.UseSpoon("WindowGrid",
               {
                  repo = 'zzspoons',
                  config = { gridGeometries = { { "6x4" } } },
                  hotkeys = {show_grid = {hyper, "g"}},
                  start = true
               }
)

----------------------------------------------------------------------

spoon.UseSpoon("ToggleScreenRotation",
               {
                  hotkeys = { first = {hyper, "f15"} }
               }
)

----------------------------------------------------------------------

spoon.UseSpoon("UniversalArchive",
               {
                  config = {
                     evernote_archive_notebook = ".Archive",
                     outlook_archive_folder = "Archive (On My Computer)",
                     archive_notifications = false
                  },
                  hotkeys = { archive = { { "ctrl", "cmd" }, "a" } }
               }
)

----------------------------------------------------------------------

spoon.UseSpoon("SendToOmniFocus",
               {
                  config = {
                     quickentrydialog = false,
                     notifications = true
                  },
                  hotkeys = {
                     send_to_omnifocus = { hyper, "t" }
                  },
                  fn = function(s)
                     s:registerApplication("Swisscom Collab", { apptype = "chromeapp", itemname = "tab" })
                     s:registerApplication("Swisscom Wiki", { apptype = "chromeapp", itemname = "wiki page" })
                     s:registerApplication("Swisscom Jira", { apptype = "chromeapp", itemname = "issue" })
                  end
               }
)

----------------------------------------------------------------------

spoon.UseSpoon("Hammer",
               {
                  repo = 'zzspoons',
                  config = { auto_reload_config = false },
                  hotkeys = {
                     config_reload = {hyper, "r"},
                     toggle_console = {hyper, "y"} 
                  },
                  start = true
               }
)

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
