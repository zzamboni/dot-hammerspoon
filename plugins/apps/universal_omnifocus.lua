--- Universal Add to Omnifocus
---- Diego Zamboni <diego@zzamboni.org>
--- Handles "send current item to OmniFocus" for multiple applications.
--- Currently Mail.app and Outlook are supported.

local mod={}

local appf=require("hs.appfinder")

mod.config={
   of_key = { {"ctrl", "cmd", "alt"}, "t" },
   of_notifications = true,
   outlook_OF_script = nil,
   mail_OF_script = nil,
   evernote_OF_script = nil,
   chrome_OF_script = nil,
}

local event=require("hs.eventtap")

--- Archive current message in Mail.app
function mod.mailOF()
   if mod.config.mail_OF_script == nil then
      notify("Hammerspoon", "You need to configure mail_OF_script before filing to Omnifocus from Mail")
   else
      notify("Mail", "Creating OmniFocus inbox item based on the selected email")
      os.execute("/usr/bin/osascript '" .. mod.config.mail_OF_script .. "'")
   end
end

--- File current Outlook message to Omnifocus
function mod.outlookOF()
   if mod.config.outlook_OF_script == nil then
      notify("Hammerspoon", "You need to configure outlook_OF_script before filing to Omnifocus from Outlook")
   else
      notify("Outlook", "Creating OmniFocus inbox item based on the selected email")
      os.execute("/usr/bin/osascript '" .. mod.config.outlook_OF_script .. "'")
   end
end

--- File selected Evernote notes to Omnifocus
function mod.evernoteOF()
   if mod.config.evernote_OF_script == nil then
      notify("Hammerspoon", "You need to configure evernote_OF_script before filing to Omnifocus from Evernote")
   else
      notify("Evernote", "Creating OmniFocus inbox item based on the selected notes")
      os.execute("/usr/bin/osascript '" .. mod.config.evernote_OF_script .. "'")
   end
end

--- File selected Evernote notes to Omnifocus
function mod.chromeOF()
   if mod.config.chrome_OF_script == nil then
      notify("Hammerspoon", "You need to configure chrome_OF_script before filing to Omnifocus from Chrome")
   else
      notify("Chrome", "Creating OmniFocus inbox item based on the current tab")
      os.execute("/usr/bin/osascript '" .. mod.config.chrome_OF_script .. "'")
   end
end

function mod.universalOF()
   local ev = appf.appFromName("Evernote")
   local mail = appf.appFromName("Mail")
   local outlook = appf.appFromName("Microsoft Outlook")
   local chrome = appf.appFromName("Google Chrome")

   if ev ~= nil and ev:isFrontmost() then
      -- Archiving Evernote notes
      mod.evernoteOF()
   elseif mail ~= nil and mail:isFrontmost() then
      -- Archiving Mail messages
      mod.mailOF()
   elseif outlook ~= nil and outlook:isFrontmost() then
      -- Archiving Outlook messages
      mod.outlookOF()
   elseif chrome ~= nil and chrome:isFrontmost() then
      -- Archiving Outlook messages
      mod.chromeOF()
   else
      notify("Hammerspoon", "I don't know how to file to Omnifocus from " .. hs.application.frontmostApplication():name())
   end
end

function mod.init()
   hs.hotkey.bind(mod.config.of_key[1], mod.config.of_key[2], hs.fnutils.partial(mod.universalOF, nil))
end

return mod
