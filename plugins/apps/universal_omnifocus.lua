--- Universal Add to Omnifocus
---- Diego Zamboni <diego@zzamboni.org>
--- Handles "send current item to OmniFocus" for multiple applications.
--- The following applications are supported:
--- - Outlook - AppleScript included in ~/.hammerspoon/scripts/, based on code from Veritrope.com
--- - Evernote - AppleScript included in ~/.hammerspoon/scripts/, based on code from www.asianefficiency.com
--- - Mail - AppleScript included in ~/.hammerspoon/scripts/, based on https://discourse.omnigroup.com/t/mail-to-quick-entry-applescript/500
--- - Chrome and any Chrome-based apps (such as SSBs created by Epichrome) - AppleScript embedded in the code below, based on original as_script from Veitrope.com. For these, set apptype = "chromeapp" to trigger the correct behavior.

local mod={}

local event=require('hs.eventtap')
local fnu=require('hs.fnutils')
local osa=require('hs.osascript')

mod.config={
   of_keys = {{ {"ctrl", "cmd", "alt"}, "t" }},
   -- Display Hammerspoon notifications (independent of AppleScript notifications, if any, generated from within the scripts)
   of_notifications = true,
   -- Display the new tasks in the OmniFocus quick-entry dialog (set to false to send directly to the Inbox)
   of_noquickentrydialog = false,
   -- User-provided actions. Don't customize here, do it in init-local.lua
   of_actions = { },
   -- Built-in actions, don't modify
   _of_actions = {
      ["Microsoft Outlook"] = {
         as_scriptfile = hs_config_dir .. "scripts/outlook-to-omnifocus.applescript",
         itemname = "message"
      },
      ["Evernote"] = {
         as_scriptfile = hs_config_dir .. "scripts/evernote-to-omnifocus.applescript",
         itemname = "note"
      },
      ["Google Chrome"] = {
         apptype = "chromeapp",
         itemname = "tab"
      },
      ["Mail"] = {
         as_scriptfile = hs_config_dir .. "scripts/mail-to-omnifocus.applescript",
         itemname = "message"
      }
   }
}

local app=require("hs.application")

function mod.mailOF()
   local mail = hs.appfinder.appFromName("Mail")
   if not mail:selectMenuItem({"Mail", "Services", "OmniFocus 2: Send to Inbox"}) then
      notify("Hammerspoon", "Something went wrong, couldn't find Mail's menu item for archiving")
   end
end

function mod.universalOF()
   local curapp = app.frontmostApplication()
   local appname = curapp:name()
   logger.df("appname = %s", appname)
   local obj = mod.config._of_actions[appname]
   if obj ~= nil then
      local itemname = (obj.itemname or "item")
      if (not (obj.as_scriptfile or obj.as_script or obj.fn or obj.apptype)) then
         notify("Hammerspoon", "You need to configure of_actions[" .. appname .. "].as_scriptfile/as_script/fn/apptype before filing to Omnifocus from " .. appname)
      else
         if mod.config.of_notifications then
            notify("Hammerspoon", "Creating OmniFocus inbox item based on the current " .. itemname)
         end
         if obj.apptype == "chromeapp" then
            obj.as_script = [[
set urlList to {}
set currentTab to 0
tell application "]] .. appname .. [["
  set chromeWindow to the front window
  set t to active tab of chromeWindow
  set tabTitle to (title of t)
  set tabURL to (URL of t)
end tell
tell front document of application "OmniFocus"
]] .. (mod.config.of_noquickentrydialog and
       [[
  make new inbox task with properties {name:("Review: " & tabTitle), note:tabURL as text}
]]
          or
          [[
  tell quick entry
    make new inbox task with properties {name:("Review: " & tabTitle), note:tabURL as text}
    open
  end tell
]]) ..
[[
end tell
display notification "Successfully exported ]] .. itemname .. [[ '" & tabTitle & "' to OmniFocus" with title "Send ]] .. itemname .. [[ to OmniFocus"]]
logger.df("obj.as_script=%s", obj.as_script)
         end
         if obj.as_scriptfile ~= nil then
            local cmd = "/usr/bin/osascript '" .. obj.as_scriptfile .. "'" .. (mod.config.of_noquickentrydialog and " nodialog" or "")
            logger.df("Executing command %s", cmd)
            os.execute(cmd)
         elseif obj.as_script ~= nil then
            logger.df("Executing AppleScript code:\n%s", obj.as_script)
            osa.applescript(obj.as_script)
         elseif obj.fn ~= nil then
            logger.df("Calling function %s", obj.fn)
            fnu.partial(obj.fn)
         end
      end
   else
      notify("Hammerspoon", "I don't know how to file to Omnifocus from " .. appname)
   end
end

function mod.init()
   -- Integrate user-provided actions into built-in ones
   for k,v in pairs(mod.config.of_actions) do mod.config._of_actions[k] = v end

   for i,kp in ipairs(mod.config.of_keys) do
      hs.hotkey.bind(kp[1], kp[2], hs.fnutils.partial(mod.universalOF, nil))
   end
end

return mod
