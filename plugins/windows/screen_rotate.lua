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
      [hs.screen.allScreens()[2]] = "f15",
-- e.g.
--                 ["HP Z24i"] = "f13",
--                 ["SyncMaster"] = "f15",
   },
   rotating_angles = { 0, 90 }, -- normal, rotated
   rotated = { },
}

mod.screens={}

function mod.setRotation(scrname, rotate)
   logger.df("mod.setRotation(%s, %s)", scrname, rotate)
   mod.config.rotated[scrname]=rotate
   mod.screens[scrname]:rotate(mod.config.rotating_angles[mod.config.rotated[scrname] and 2 or 1])
end

function mod.toggleRotation(scrname)
   logger.df("mod.toggleRotation(%s)", scrname)
   mod.setRotation(scrname, not mod.config.rotated[scrname])
end

function mod.init()
   for k,v in pairs(mod.config.toggle_rotate_keys) do
      local scr = hs.screen.find(k)
      if scr ~= nil then
         scrname = scr:name()
         mod.screens[scrname] = scr
         logger.df("Setting up rotation for screen %s with key %s", scrname, v)
         local mode = scr:currentMode()
         -- Determine if the screen is currently rotated
         mod.setRotation(scrname, mode.h > mode.w)
         omh.bind({ mod.config.toggle_rotate_modifier, v }, hs.fnutils.partial(mod.toggleRotation, scrname))
      end
   end

   if type(mod.config.rotating_screen) == "string" then
      mod.config.rotating_screen=hs.screen.find(mod.config.rotating_screen)
   end
   logger.df("rotating_screen: %s", mod.config.rotating_screen)
   if mod.config.rotating_screen ~= nil then
      logger.d("Setting up screen rotation")
      local mode = mod.config.rotating_screen:currentMode()
      -- Determine if the screen is currently rotated
      mod.setRotation(mode.h > mode.w)
      logger.d("Setting up keybinding for screen rotation")
      omh.bind(mod.config.toggle_rotate_key, mod.toggleRotation)
   else
      logger.d("No rotating screen found, skipping setup")
   end
end

return mod
