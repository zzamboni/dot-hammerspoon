--- Universal Add to Omnifocus
---- Diego Zamboni <diego@zzamboni.org>
--- Handles "send current item to OmniFocus" for multiple applications.
--- Currently Mail.app and Outlook are supported.

local mod={}

local event=require('hs.eventtap')
local fnu=require('hs.fnutils')

mod.config={
   of_keys = {{ {"ctrl", "cmd", "alt"}, "t" }},
   of_notifications = true,
   of_actions = {
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
   local obj = mod.config.of_actions[appname]
   if obj ~= nil then
      if obj.script ~= nil then
         notify("Hammerspoon", "Creating OmniFocus inbox item based on the current " .. (obj.itemname or "item"))
         os.execute("/usr/bin/osascript '" .. obj.script .. "'")
      elseif obj.fn ~= nil then
         notify("Hammerspoon", "Creating OmniFocus inbox item based on the current " .. (obj.itemname or "item"))
         logger.df("obj.fn=%s", obj.fn)
         fnu.partial(obj.fn)
      else
         notify("Hammerspoon", "You need to configure of_actions[" .. appname .. "].script/fn before filing to Omnifocus from " .. appname)
      end
   else
      notify("Hammerspoon", "I don't know how to file to Omnifocus from " .. appname)
   end
end

function mod.init()
   for i,kp in ipairs(mod.config.of_keys) do
      hs.hotkey.bind(kp[1], kp[2], hs.fnutils.partial(mod.universalOF, nil))
   end
end

return mod
