-- Global log level. Per-spoon log level can be configured in each block below
hs.logger.defaultLogLevel="info"

-- Some useful variables for key binding specifications in Spoon configurations
hyper = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}

-- Useful color map I use in some configurations below
col = hs.drawing.color.x11

----------------------------------------------------------------------
-- Set up SpoonInstall - this is the only spoon that needs to be
-- manually installed (it is already there if you check out this
-- repository), all the others are installed and configured
-- automatically.
----------------------------------------------------------------------

hs.loadSpoon("SpoonInstall")

-- Configuration of my personal spoon repository, which contains Spoons
-- that have not been merged in the main repo.
-- See the descriptions at http://zzamboni.org/zzSpoons/
spoon.SpoonInstall.repos.zzspoons = {
   url = "https://github.com/zzamboni/zzSpoons",
   desc = "zzamboni's spoon repository",
}

-- I prefer sync notifications, makes them easier to read
spoon.SpoonInstall.use_syncinstall = true

-- This is just a shortcut to make the declarations below look more readable,
-- i.e. `Install:andUse()` instead of `spoon.SpoonInstall:andUse()`
Install=spoon.SpoonInstall

----------------------------------------------------------------------

-- http://www.hammerspoon.org/Spoons/MouseCircle.html
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

-- http://www.hammerspoon.org/Spoons/BrewInfo.html
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

-- http://www.hammerspoon.org/Spoons/URLDispatcher.html
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

-- http://www.hammerspoon.org/Spoons/Caffeine.html
Install:andUse("Caffeine")

----------------------------------------------------------------------

-- http://www.hammerspoon.org/Spoons/MenubarFlag.html
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

-- http://zzamboni.org/zzSpoons/WindowHalfsAndThirds.html
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

-- http://zzamboni.org/zzSpoons/WindowScreenLeftAndRight.html
Install:andUse("WindowScreenLeftAndRight",
               {
                  repo = 'zzspoons',
                  hotkeys = 'default'
               }
)

----------------------------------------------------------------------

-- http://zzamboni.org/zzSpoons/WindowGrid.html
Install:andUse("WindowGrid",
               {
                  repo = 'zzspoons',
                  config = { gridGeometries = { { "6x4" } } },
                  hotkeys = {show_grid = {hyper, "g"}},
                  start = true
               }
)

----------------------------------------------------------------------

-- http://www.hammerspoon.org/Spoons/ToggleScreenRotation.html
Install:andUse("ToggleScreenRotation",
               {
                  hotkeys = { first = {hyper, "f15"} }
               }
)

----------------------------------------------------------------------

-- http://www.hammerspoon.org/Spoons/UniversalArchive.html
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

-- http://www.hammerspoon.org/Spoons/SendToOmniFocus.html
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

-- http://zzamboni.org/zzSpoons/Hammer.html
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

-- http://zzamboni.org/zzSpoons/ToggleSkypeMute.html
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

-- http://www.hammerspoon.org/Spoons/Emojis.html
Install:andUse("Emojis",
               {
                  disable = true,
                  hotkeys = { toggle = { hyper, "e" } }
               }
)

----------------------------------------------------------------------

-- http://zzamboni.org/zzSpoons/HeadphoneWatcher.html
Install:andUse("HeadphoneWatcher",
               {
                  repo = 'zzspoons',
                  start = true
               }
)

----------------------------------------------------------------------

-- http://zzamboni.org/zzSpoons/EvernoteOpenAndTag.html
Install:andUse("EvernoteOpenAndTag",
               {
                  repo = 'zzspoons',
                  hotkeys = {
                     open_note = { hyper, "o" },
                     ["open_and_tag-+work,+swisscom"] = { hyper, "w" },
                     ["open_and_tag-+personal"] = { hyper, "p" },
                     ["tag-@zzdone"] = { hyper, "z" }
                  }
               }
)

----------------------------------------------------------------------

-- http://www.hammerspoon.org/Spoons/Seal.html
Install:andUse("Seal",
               {
                  hotkeys = { show = { {"cmd"}, "space" } },
                  fn = function(s)
                     s:loadPlugins({"apps", "calc", "safari_bookmarks"})
                  end,
                  start = true,
               }
)

----------------------------------------------------------------------

-- http://zzamboni.org/zzSpoons/TextClipboardHistory.html
Install:andUse("TextClipboardHistory",
               {
                  repo = 'zzspoons',
                  config = {
                     show_in_menubar = false,
                  },
                  hotkeys = {
                     toggle_clipboard = { { "cmd", "shift" }, "v" } },
                  start = true,
               }
)

----------------------------------------------------------------------

-- http://zzamboni.org/zzSpoons/ColorPicker.html
Install:andUse("ColorPicker",
               {
                  repo = 'zzspoons',
                  hotkeys = {
                     show = { shift_hyper, "c" }
                  },
                  config = {
                     show_in_menubar = false,
                  },
                  start = true,
               }
)

----------------------------------------------------------------------
-- Test stuff

-- https://github.com/Hammerspoon/hammerspoon/issues/1356#issuecomment-300707447
require('hs.ipc2')

-- Get onenote: link to the current OneNote page or section. Defaults to Page - pass `"Section"` as the argument to get the current section URI.
function getOneNoteURI(what)
   local obj = what or "Page"
   local menu="Copy Link to " .. obj
   local app=hs.appfinder.appFromName("Microsoft OneNote")
   if app then
      local i=app:findMenuItem(menu)
      if i then
         app:selectMenuItem(menu)
         -- 1/50th of a second wait to give the pasteboard a chance to catch up
         hs.timer.usleep(20000)
         local links=hs.pasteboard.getContents()
         if links then
            -- Remove the web URL part and leave the onenote: part
            return links:match("(onenote:.*)$")
         end
      end
   end
   return nil
end

----------------------------------------------------------------------

-- http://zzamboni.org/zzSpoons/FadeLogo.html
Install:andUse("FadeLogo",
               {
                  repo = 'zzspoons',
                  config = {
                     default_run = 1.0,
                  },
                  start = true
               }
)

-- If you don't want to use FadeLogo, you can have a regular notification
-- hs.notify.show("Welcome to Hammerspoon", "Have fun!", "")
