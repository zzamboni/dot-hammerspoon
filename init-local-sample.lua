-- Uncomment to set non-default log level
-- logger.setLogLevel('debug')

-- Local code and config

--[[

omh_config("mouse.locator",
           {
              color = hs.drawing.color.x11.rebeccapurple,
           })

omh_config("apps.universal_archive",
           {
              evernote_archive_notebook = ".Archive",
              evernote_other_archives = {
                 -- Notebook = Key binding
                 Quenah = { {"Ctrl", "Cmd"}, "q" }
              },
              archive_notifications = false,
           })

omh_config("misc.clipboard",
           {
              show_menu_counter = false,
           })

omh_config("misc.colorpicker",
           {
              colorpicker_in_menubar = false,
           })

--]]
