--- Screen rotation
-- Diego Zamboni <diego@zzamboni.org>

-- Toggles rotation on an arbitrary number of external screens, defined in toggle_rotate_keys, which
-- has keys named after each scren, with the values corresponding to the key that will be used to toggle
-- its rotation. Defaults to the first external monitor, toggled with Ctrl-Cmd-Shift-F15
--
-- Makes the following simplifying assumptions:
-- * That you only toggle between two positions for rotated/not rotated (configured in rotating_angles, and
--   which apply to all screens)
-- * That "rotated" means "taller than wider", for the purposes of determining if the screen is rotated upon
--   initialization.

local mod={}

mod.config={
   toggle_rotate_modifier = { "Ctrl", "Cmd", "Alt"},
   toggle_rotate_keys = {
      [".*"] = "f15"
-- e.g.
--                 ["HP Z24i"] = "f13",
--                 ["SyncMaster"] = "f15",
   },
    -- Lua patterns for screens that shouldn't be rotated, even if they match one of the patterns
   screens_to_skip = { "Color LCD" },
   rotating_angles = { 0, 90 }, -- normal, rotated
   rotated = { },
}

mod.screens={}

local fn = require("hs.fnutils")
local screen = require("hs.screen")

function mod.setRotation(scrname, rotate)
   omh.logger.df("mod.setRotation(%s, %s)", scrname, rotate)
   if mod.screens[scrname] ~= nil then
      mod.config.rotated[scrname]=rotate
      mod.screens[scrname]:rotate(mod.config.rotating_angles[mod.config.rotated[scrname] and 2 or 1])
   end
end

function mod.toggleRotation(scrname)
   omh.logger.df("mod.toggleRotation(%s)", scrname)
   mod.findScreens()
   if mod.screens[scrname] ~= nil then
      omh.logger.i(string.format("Rotating screen '%s' (matching key '%s')", mod.screens[scrname]:name(), scrname))
      mod.setRotation(scrname, not mod.config.rotated[scrname])
   else
      omh.logger.wf("Rotation triggered, but I didn't find any screen matching '%s' - skipping", scrname)
   end
end

function filteredScreenFind(scr)
   local scrs = { screen.find(scr) }
   for i,s in ipairs(scrs) do
      local match = false
      for j,p in ipairs(mod.config.screens_to_skip) do
         if string.match(s:name(), p) then
            match = true
         end
      end
      if not match then
         return s
      end
   end
   return nil
end

function mod.findScreens()
   for k,v in pairs(mod.config.toggle_rotate_keys) do
      local scr = filteredScreenFind(k)
      mod.screens[k] = scr
      if scr ~= nil then
         scrname = scr:name()
         omh.logger.df("Found screen %s (matching key '%s'), setting up for rotation", scrname, k)
         local mode = scr:currentMode()
         -- Determine if the screen is currently rotated
         mod.setRotation(k, mode.h > mode.w)
      else
         omh.logger.df("Found no screen matching '%s', skipping rotation", k)
      end
   end
end

function mod.init()
   for k,v in pairs(mod.config.toggle_rotate_keys) do
      omh.logger.df("Setting up screen binding rotation for screen matching '%s' with key %s", k, v)
      omh.bind({ mod.config.toggle_rotate_modifier, v }, fn.partial(mod.toggleRotation, k))
   end
end

return mod
