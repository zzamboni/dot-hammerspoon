-- Evernote automation
-- Diego Zamboni <diego@zzamboni.org>

--[[
   Supported so far:

   - Key binding for opening current note in separate window.
     Configure in `open_note_key`
   - Key bindings for opening current note in a window and setting tags
     (leaves the cursor in the tags field). Configure in `modifiers_for_tagging`
     and `keys_for_open_and_tag`.
   - Key bindings for tagging current note inline. Configure in `modifiers_for_tagging`
     and `keys_for_inline_tagging`.
--]]

local mod = {}

mod.config = {
   open_note_key = { {'cmd', 'alt', 'ctrl'}, 'o'},
   modifiers_for_tagging = {'cmd', 'alt', 'ctrl'},
   keys_for_open_and_tag = {
-- e.g.
--      w = {"@computer", "work"}
   },
   keys_for_inline_tagging = {
-- e.g.
--      z = {"done"}
   },
}

local as = require("hs.osascript")
local event=require("hs.eventtap")
local fn=require("hs.fnutils")
local app=require("hs.appfinder")

function mod.evernoteIsFrontmost()
   local ev = app.appFromName("Evernote")
   return(ev ~= nil and ev:isFrontmost())
end

-- Applescript from https://discussion.evernote.com/topic/85685-feature-request-open-note-in-separate-window-keyboard-shortcut/#comment-366797
function mod.openNoteInWindow()
   if mod.evernoteIsFrontmost() then
      as.applescript([[tell application "Evernote"
	set _sel to selection -- Gets the Note(s) Selected in Evernote
	if _sel ≠ {} then
--		set aNote to first item of _sel -- Get ONLY the 1st Note
                repeat with aNote in _sel
		    open note window with aNote
                end repeat
	end if
end tell]])
   end   
end

function mod.tagNote(tags)
   event.keyStroke({"cmd"}, "'")
   event.keyStroke({"cmd"}, "a")
   for i,t in ipairs(tags) do
      event.keyStrokes(t .. "\n")
   end
end

function mod.openAndTagNote(tags)
   if mod.evernoteIsFrontmost() then
      mod.openNoteInWindow()
      mod.tagNote(tags)
   end
end

function mod.inlineTagNote(tags)
   if mod.evernoteIsFrontmost() then
      mod.tagNote(tags)
      event.keyStrokes("\n")
   end
end

function mod.init()
   omh.bind(mod.config.open_note_key, mod.openNoteInWindow)
   for k,tags in pairs(mod.config.keys_for_open_and_tag) do
      omh.bind({mod.config.modifiers_for_tagging, k}, fn.partial(mod.openAndTagNote, tags))
   end
   for k,tags in pairs(mod.config.keys_for_inline_tagging) do
      omh.bind({mod.config.modifiers_for_tagging, k}, fn.partial(mod.inlineTagNote, tags))
   end
end

return mod
