--- Universal Add to Omnifocus
---- Diego Zamboni <diego@zzamboni.org>
--- Handles "send current item to OmniFocus" for multiple applications.
--- Currently Mail.app and Outlook are supported.

local mod={}

mod.config={
   of_key = { {"ctrl", "cmd", "alt"}, "t" }, 
   of_notifications = true,
   of_scripts = {
      -- Sample structure, you need to provide your own scripts
      -- script is mandatory, itemname is optional, defaults to "item".
      -- ["Microsoft Outlook"] = {
      --    script = "/Users/taazadi1/Library/Scripts/Applications/Outlook/Send to OmniFocus with attached message.scpt",
      --    itemname = "message"
      -- },
      -- ["Evernote"] = {
      --    script = "/Users/taazadi1/Library/Scripts/Applications/Evernote/Send selected notes to Omnifocus.scpt",
      --    itemname = "note"
      -- },
      -- ["Google Chrome"] = {
      --    script = "/Users/taazadi1/Library/Scripts/Applications/Chrome/Save current Chrome tab to Omnifocus.scpt",
      --    itemname = "tab"
      -- },
   }
}

local event=require("hs.eventtap")
local app=require("hs.application")

function mod.file_to_OF(appname, obj)
   if obj.script == nil then
      notify("Hammerspoon", "You need to configure of_scripts[" .. appname .. "].script before filing to Omnifocus from " .. appname)
   else
      notify("Chrome", "Creating OmniFocus inbox item based on the current " .. (obj.itemname or "item"))
      os.execute("/usr/bin/osascript '" .. obj.script .. "'")
   end
end

function mod.universalOF()
   local curapp = app.frontmostApplication()
   local appname = curapp:name()
   logger.df("appname = %s", appname)

   if mod.config.of_scripts[appname] ~= nil then
      mod.file_to_OF(appname, mod.config.of_scripts[appname])
   else
      notify("Hammerspoon", "I don't know how to file to Omnifocus from " .. appname)
   end
end

function mod.init()
   hs.hotkey.bind(mod.config.of_key[1], mod.config.of_key[2], hs.fnutils.partial(mod.universalOF, nil))
end

return mod
