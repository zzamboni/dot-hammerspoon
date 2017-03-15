--- Universal Add to Omnifocus
---- Diego Zamboni <diego@zzamboni.org>
--- Handles "send current item to OmniFocus" for multiple applications.
--- Currently Mail.app and Outlook are supported.

local mod={}

mod.config={
   of_key = { {"ctrl", "cmd", "alt"}, "t" }, 
   of_notifications = true,
   of_scripts = {
      ["Microsoft Outlook"] = {
         script = hs_config_dir .. "scripts/outlook-to-omnifocus.applescript",
         itemname = "message"
      },
      ["Evernote"] = {
         script = hs_config_dir .. "scripts/evernote-to-omnifocus.applescript",
         itemname = "note"
      },
      ["Google Chrome"] = {
         script = hs_config_dir .. "scripts/chrome-to-omnifocus.applescript",
         itemname = "tab"
      },
   }
}

local app=require("hs.application")

function mod.universalOF()
   local curapp = app.frontmostApplication()
   local appname = curapp:name()
   logger.df("appname = %s", appname)
   local obj = mod.config.of_scripts[appname]
   if obj ~= nil then
      if obj.script == nil then
         notify("Hammerspoon", "You need to configure of_scripts[" .. appname .. "].script before filing to Omnifocus from " .. appname)
      else
         notify("Chrome", "Creating OmniFocus inbox item based on the current " .. (obj.itemname or "item"))
         os.execute("/usr/bin/osascript '" .. obj.script .. "'")
      end
   else
      notify("Hammerspoon", "I don't know how to file to Omnifocus from " .. appname)
   end
end

function mod.init()
   hs.hotkey.bind(mod.config.of_key[1], mod.config.of_key[2], hs.fnutils.partial(mod.universalOF, nil))
end

return mod
