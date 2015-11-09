--- Screen rotation
-- Diego Zamboni <diego@zzamboni.org>

-- Makes the following simplifying assumptions:
-- * That you only have one rotation-capable monitor (configured in rotating_screen, defaults to second
--   monitor - on a laptop this means the first external monitor)
-- * That you only toggle between two positions for rotated/not rotated (configured in rotating_angles)
-- * That "rotated" means "taller than wider", for the purposes of determining if the screen is rotated upon
--   initialization.

local mod={}

mod.rotated=nil

mod.config={
   rotating_screen = hs.screen.allScreens()[2],
   toggle_rotate_key = { { "Ctrl", "Cmd", "Alt"}, "f15"},
   rotating_angles = { 0, 90 } -- normal, rotated
}

function mod.setRotation(rotate)
   mod.rotated=rotate
   mod.config.rotating_screen:rotate(mod.config.rotating_angles[mod.rotated and 2 or 1])
end

function mod.toggleRotation()
   mod.setRotation(not mod.rotated)
end

function mod.init()
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
