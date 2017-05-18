hs.logger.defaultLogLevel="info"

require("oh-my-hammerspoon")

hyper = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}
local col = hs.drawing.color.x11

----------------------------------------------------------------------
-- Set up SpoonInstall - this is the only spoon that needs to be
-- manually installed, all the others are installed and configured
-- automatically.
----------------------------------------------------------------------
hs.loadSpoon("SpoonInstall")
-- Configuration of my personal spoon repository
spoon.SpoonInstall.repos.zzspoons = {
   url = "https://github.com/zzamboni/zzSpoons",
   desc = "zzamboni's spoon repository",
}
-- I prefer sync notifications, makes them easier to read
spoon.SpoonInstall.use_syncinstall = true

-- This is just a shortcut to make the declarations below look better
Install=spoon.SpoonInstall

----------------------------------------------------------------------

Install:andUse("MouseCircle",
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

Install:andUse("BrewInfo",
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

Install:andUse("URLDispatcher",
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
                        { "https?://app.opsgenie.com", "org.epichrome.app.OpsGenie" },
                     },
                     default_handler = "com.google.Chrome"
                  },
                  start = true
               }
)

----------------------------------------------------------------------

Install:andUse("Caffeine")

----------------------------------------------------------------------

Install:andUse("MenubarFlag",
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

Install:andUse("WindowHalfsAndThirds",
               {
                  repo = 'zzspoons',
                  config = {
                     use_frame_correctness = true
                  },
                  hotkeys = 'default'
               }
)

----------------------------------------------------------------------

Install:andUse("WindowScreenLeftAndRight",
               {
                  repo = 'zzspoons',
                  hotkeys = 'default'
               }
)

----------------------------------------------------------------------

Install:andUse("WindowGrid",
               {
                  repo = 'zzspoons',
                  config = { gridGeometries = { { "6x4" } } },
                  hotkeys = {show_grid = {hyper, "g"}},
                  start = true
               }
)

----------------------------------------------------------------------

Install:andUse("ToggleScreenRotation",
               {
                  hotkeys = { first = {hyper, "f15"} }
               }
)

----------------------------------------------------------------------

Install:andUse("UniversalArchive",
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

Install:andUse("SendToOmniFocus",
               {
                  config = {
                     quickentrydialog = false,
                     notifications = false
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

Install:andUse("Hammer",
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

Install:andUse("ToggleSkypeMute",
               {
                  repo = 'zzspoons',
                  hotkeys = {
                     toggle_skype = { shift_hyper, "v" },
                     toggle_skype_for_business = { shift_hyper, "f" }
                  }
               }
)

----------------------------------------------------------------------

-- Install:andUse("Emojis",
--                {
--                   hotkeys = { toggle = { hyper, "e" } }
--                }
-- )

----------------------------------------------------------------------

Install:andUse("HeadphoneWatcher",
               {
                  repo = 'zzspoons',
                  start = true
               }
)

----------------------------------------------------------------------

Install:andUse("EvernoteOpenAndTag",
               {
                  hotkeys = {
                     open_note = { hyper, "o" },
                     ["open_and_tag-+work,+swisscom"] = { hyper, "w" },
                     ["open_and_tag-+personal"] = { hyper, "p" },
                     ["tag-@zzdone"] = { hyper, "z" }
                  }
               }
)
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
      --      "apps.skype_mute",
      --      "mouse.locator",
      --      "audio.headphones_watcher",
      "misc.clipboard",
      "misc.colorpicker",
      --      "keyboard.menubar_indicator",
      --      "apps.universal_archive",
      --      "apps.universal_omnifocus",
      --      "windows.screen_rotate",
      --      "apps.evernote",
      --      "misc.url_handling",
      --      "omh.brew_info",
      --      "misc.presentation",
})
