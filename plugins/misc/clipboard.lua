--[[
   From https://github.com/victorso/.hammerspoon/blob/master/tools/clipboard.lua
   Converted to plugin by Diego Zamboni

   This is my attempt to implement a jumpcut replacement in Lua/Hammerspoon.
   It monitors the clipboard/pasteboard for changes, and stores the strings you copy to the transfer area.
   You can access this history on the menu (Unicode scissors icon).
   Clicking on any item will add it to your transfer area.
   If you open the menu while pressing option/alt, you will enter the Direct Paste Mode. This means that the selected item will be
   "typed" instead of copied to the active clipboard.
   The clipboard persists across launches.
   -> Ng irc suggestion: hs.settings.set("jumpCutReplacementHistory", clipboard_history)
]]--

local mod={}

-- Feel free to change these settings
mod.config = {
   -- Key binding
   clipboard_menu_key = { {"cmd", "shift"}, "v" },
   -- Speed in seconds to check for clipboard changes. If you check
   -- too frequently, you will loose performance, if you check
   -- sparsely you will loose copies
   frequency = 0.8,
   -- How many items to keep on history
   hist_size = 100,
   -- How wide (in characters) the dropdown menu should be. Copies
   -- larger than this will have their label truncated and end with
   -- "…" (unicode for elipsis ...)
   label_length = 70,
   --asmagill request. If any application clears the pasteboard, we
   --also remove it from the history
   --https://groups.google.com/d/msg/hammerspoon/skEeypZHOmM/Tg8QnEj_N68J
   honor_clearcontent = false,
   -- Auto-type on click
   paste_on_select = false,
   -- Show item count in the menu item
   show_menu_counter = true,
   -- Show menu in the menubar
   show_in_menubar = true,
   -- Title to show on the menubar, if enabled above
   menubar_title = "\u{1F4CB}",
   -- Use hs.menubar or hs.chooser?
   use_chooser = (hs.chooser ~= nil),
}

-- Chooser/menu object
mod.selectorobj = nil
-- Cache for focused window to work around the current window losing focus after the chooser comes up
mod.prevFocusedWindow = nil

-- Don't change anything bellow this line
local pasteboard = require("hs.pasteboard") -- http://www.hammerspoon.org/docs/hs.pasteboard.html
local settings = require("hs.settings") -- http://www.hammerspoon.org/docs/hs.settings.html
local last_change = pasteboard.changeCount() -- displays how many times the pasteboard owner has changed // Indicates a new copy has been made

--Array to store the clipboard history
local clipboard_history = settings.get("so.victor.hs.jumpcut") or {} --If no history is saved on the system, create an empty history

-- Append a history counter to the menu
function setTitle()
   if not mod.config.use_chooser then
      if ((#clipboard_history == 0) or (mod.config.show_menu_counter == false)) then
         -- Clipboard Emoji: http://emojipedia.org/clipboard/
         mod.selectorobj:setTitle(mod.config.menubar_title) -- Unicode magic
      else
         mod.selectorobj:setTitle(mod.config.menubar_title .. " ("..#clipboard_history..")") -- updates the menu counter
      end
   end
end

function putOnPaste(value,key)
   if mod.prevFocusedWindow ~= nil then
      mod.prevFocusedWindow:focus()
   end
   if value == nil then return end
   if type(value) == "string" then
      pasteboard.setContents(value)
   else if type(value) == "table" then
         if value.image ~= nil then
            pasteboard.setImageContents(value.image)
         else
            pasteboard.setContents(value.text)
         end
        else
           if pasteboard.setImageContents ~= nil then
              pasteboard.setImageContents(value)
           end
        end
   end
   last_change = pasteboard.changeCount()

   if (mod.config.paste_on_select) then
      hs.eventtap.keyStroke({"cmd"}, "v")
   else
      if (key.alt == true) then -- If the option/alt key is active when clicking on the menu, perform a "direct paste", without changing the clipboard
         hs.eventtap.keyStroke({"cmd"}, "v") -- Defeating paste blocking http://www.hammerspoon.org/go/#pasteblock
      end
   end
end

-- Clears the clipboard and history
function clearAll()
   pasteboard.clearContents()
   clipboard_history = {}
   settings.set("so.victor.hs.jumpcut",clipboard_history)
   now = pasteboard.changeCount()
   setTitle()
end

-- Clears the last added to the history
function clearLastItem()
   table.remove(clipboard_history,#clipboard_history)
   settings.set("so.victor.hs.jumpcut",clipboard_history)
   now = pasteboard.changeCount()
   setTitle()
end

function pasteboardToClipboard(item)
   -- Loop to enforce limit on qty of elements in history. Removes the oldest items
   while (#clipboard_history >= mod.config.hist_size) do
      table.remove(clipboard_history,1)
   end
   table.insert(clipboard_history, item)
   settings.set("so.victor.hs.jumpcut",clipboard_history) -- updates the saved history
   setTitle() -- updates the menu counter
end

-- Dynamic menu by cmsj https://github.com/Hammerspoon/hammerspoon/issues/61#issuecomment-64826257
populateMenubar = function(key)
   setTitle() -- Update the counter every time the menu is refreshed
   menuData = {}
   if (#clipboard_history == 0) then
      table.insert(menuData, {title="None", disabled = true}) -- If the history is empty, display "None"
   else
      for k,v in pairs(clipboard_history) do
         if (type(v) == "string" and string.len(v) > mod.config.label_length) then
            table.insert(menuData,1, {title=string.sub(v,0,mod.config.label_length).."…", fn = function() putOnPaste(v,key) end }) -- Truncate long strings
         else
            if type(v) == "userdata" then
               table.insert(menuData,1, {title="(image)", fn = function() putOnPaste(v,key) end })
            else
               table.insert(menuData,1, {title=v, fn = function() putOnPaste(v,key) end })
            end
         end -- end if else
      end-- end for
   end-- end if else
   -- footer
   table.insert(menuData, {title="-"})
   table.insert(menuData, {title="Clear All", fn = function() clearAll() end })
   if (key.alt == true or mod.config.paste_on_select) then
      table.insert(menuData, {title="Direct Paste Mode ✍", disabled=true})
   end
   return menuData
end

populateChooser = function(key)
   menuData = {}
   if (#clipboard_history == 0) then
      table.insert(menuData, {text="", subtext = "Clipboard history is empty"}) -- If the history is empty, display "None"
   else
      for k,v in pairs(clipboard_history) do
         if (type(v) == "string") then
            table.insert(menuData,1, {text=v, subText=""})
         else
            if type(v) == "userdata" then
               table.insert(menuData,1, {text="(image)", subText = "", image=v })
            else
               table.insert(menuData,1, {text=v, subText = ""})
            end
         end -- end if else
      end-- end for
   end-- end if else
   -- footer
   -- table.insert(menuData, {title="-"})
   -- table.insert(menuData, {title="Clear All", fn = function() clearAll() end })
   -- if (key.alt == true or mod.config.paste_on_select) then
   --    table.insert(menuData, {title="Direct Paste Mode ✍", disabled=true})
   -- end
   return menuData
end

-- If the pasteboard owner has changed, we add the current item to our history and update the counter.
function storeCopy()
   now = pasteboard.changeCount()
   if (now > last_change) then
      current_clipboard = pasteboard.getContents()
      logger.df("current_clipboard (text) = %s", current_clipboard)
      if (current_clipboard == nil) and (pasteboard.getImageContents ~= nil) then
         pcall(function() current_clipboard = pasteboard.getImageContents() end)
         logger.df("current_clipboard (image) = %s", current_clipboard)
      end
      -- asmagill requested this feature. It prevents the history from keeping items removed by password managers
      if (current_clipboard == nil and mod.config.honor_clearcontent) then
         clearLastItem()
      else
         logger.df("Adding %s to clipboard history", current_clipboard)
         pasteboardToClipboard(current_clipboard)
      end
      last_change = now
   end
end

function mod.init()
   if mod.config.use_chooser then
      mod.selectorobj = hs.chooser.new(putOnPaste)
      mod.selectorobj:choices(populateChooser)
      omh.bind(mod.config.clipboard_menu_key,
               function()
                  logger.d("Refreshing chooser choices")
                  mod.selectorobj:refreshChoicesCallback()
                  logger.d("Storing currently focused window")
                  mod.prevFocusedWindow = hs.window.focusedWindow()
                  logger.d("Calling mod.selectorobj:show()")
                  mod.selectorobj:show()
               end)
   else
      mod.selectorobj = hs.menubar.new(mod.config.show_in_menubar)
      mod.selectorobj:setTooltip("Clipboard history")
      mod.selectorobj:setMenu(populateMenubar)
      omh.bind(mod.config.clipboard_menu_key, function() mod.selectorobj:popupMenu(hs.mouse.getAbsolutePosition()) end)
   end

   --Checks for changes on the pasteboard. Is it possible to replace with eventtap?
   timer = hs.timer.new(mod.config.frequency, storeCopy)
   timer:start()

   setTitle() --Avoid wrong title if the user already has something on his saved history

end

return mod
