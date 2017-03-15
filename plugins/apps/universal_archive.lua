--- Universal Archive
---- Diego Zamboni <diego@zzamboni.org>
--- Handles "archive current item" for multiple applications.
--- Currently Evernote and Mail.app are supported.
--- For Evernote, also allows specifying other keybindings for
--- archiving directly to different notebooks.


local mod={}

mod.config={
   archive_key = { {"Ctrl", "Cmd"}, "a" },
   evernote_archive_notebook = "Archive",
   evernote_other_archives = {},
   outlook_archive_folder = "Archive",
   archive_notifications = true,
   -- Do not change these unless you know what you are doing
   evernote_delay_before_typing = 0.2,
   outlook_delay_before_typing = 0.2,
}

local event=require("hs.eventtap")

function mod.evernoteArchive(where)
   local ev = hs.appfinder.appFromName("Evernote")
   -- Archiving Evernote notes
   if ev:selectMenuItem({"Note", "Move To Notebook…"}) then
      local dest = where 
      if dest == nil then
         dest = mod.config.evernote_archive_notebook
      end
      if mod.config.archive_notifications then
         notify("Evernote", "Archiving note to " .. dest)
      end
      omh.sleep(mod.config.evernote_delay_before_typing)
      event.keyStrokes(dest .. "\n")
   else
      notify("Hammerspoon", "Something went wrong, couldn't find Evernote's menu item for archiving")
   end
end

--- Archive current message in Mail.app
function mod.mailArchive()
   local mail = hs.appfinder.appFromName("Mail")
   if mail:selectMenuItem({"Message", "Archive"}) then
      if mod.config.archive_notifications then
         notify("Mail", "Archiving message")
      end
   else
      notify("Hammerspoon", "Something went wrong, couldn't find Mail's menu item for archiving")
   end
end

--- Archive current message in Spark
function mod.sparkArchive()
   local spark = hs.appfinder.appFromName("Spark")
   if spark:selectMenuItem({"Message", "Archive"}) then
      if mod.config.archive_notifications then
         notify("Spark", "Archiving message")
      end
   else
      notify("Hammerspoon", "Something went wrong, couldn't find Spark's menu item for archiving")
   end
end

--- Archive current message in Outlook
function mod.outlookArchive(where)
   local outlook = hs.appfinder.appFromName("Microsoft Outlook")
   if outlook:selectMenuItem({"Message", "Move", mod.config.outlook_archive_folder}) then
      if mod.config.archive_notifications then
         notify("Outlook", "Archiving message")
      end
   else
      notify("Hammerspoon", "Something went wrong, couldn't find Outlook's menu item for archiving")
   end
end

function mod.universalArchive(where)
   local ev = hs.appfinder.appFromName("Evernote")
   local mail = hs.appfinder.appFromName("Mail")
   local spark = hs.appfinder.appFromName("Spark")
   local outlook = hs.appfinder.appFromName("Microsoft Outlook")

   if ev ~= nil and ev:isFrontmost() then
      -- Archiving Evernote notes
      mod.evernoteArchive(where)
   elseif mail ~= nil and mail:isFrontmost() then
      -- Archiving Mail messages
      mod.mailArchive()
   elseif spark ~= nil and spark:isFrontmost() then
      -- Archiving Mail messages in Spark
      mod.sparkArchive()
   elseif outlook ~= nil and outlook:isFrontmost() then
      -- Archiving Outlook messages
      mod.outlookArchive()
   else
      notify("Hammerspoon", "I don't know how to archive in " .. hs.application.frontmostApplication():name())
   end
end

function mod.init()
   hs.hotkey.bind(mod.config.archive_key[1], mod.config.archive_key[2], hs.fnutils.partial(mod.universalArchive, nil))
   for k,v in pairs(mod.config.evernote_other_archives) do
      hs.hotkey.bind(v[1], v[2], hs.fnutils.partial(mod.universalArchive, k))
   end
end

return mod
