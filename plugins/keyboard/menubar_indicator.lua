--- Menubar keyboard-layout indicator
---- Functionality inspired by ShowyEdge (https://pqrs.org/osx/ShowyEdge/index.html.en)
---- Code by Diego Zamboni <diego@zzamboni.org>

local mod={}

local as = require "hs.applescript"
local scr = require "hs.screen"
local draw = require "hs.drawing"
local geom = require "hs.geometry"
local tasks = nil
if hs.task ~= nil then
   tasks = require "hs.task"
end
local fn = require "hs.fnutils"
local keyc = require "hs.keycodes"
local timers = require "hs.timer"
local col
if draw.color.x11 ~= nil then
   col = draw.color.x11
else
   col = draw.color
end
local timer
local prevlayout = nil
local task = nil

mod.config = {
   -- Global enable/disable
   enableIndicator = true,
   -- Display on all monitors or just the current one?
   allScreens = true,
   -- Specify 0.0-1.0 to specify a percentage of the height of the menu bar, larger values indicate a fixed height in pixels
   indicatorHeight = 1.0,
   -- transparency (1.0 - fully opaque)
   indicatorAlpha = 0.3,
   -- show the indicator in all spaces (this includes full-screen mode)
   indicatorInAllSpaces = true,

   -- enable a timer as a workaround to the current bug that prevents keyboard-layout
   -- events from being generated sometimes. If so, how frequently should the timer fire?
   -- https://github.com/Hammerspoon/hammerspoon/issues/615
   enable_timer = false,
   timer_frequency = 1,

   ---- Configuration of indicator colors

   -- Each indicator is made of an arbitrary number of segments,
   -- distributed evenly across the width of the screen. The table below
   -- indicates the colors to use for a given keyboard layout. The index
   -- is the name of the layout as it appears in the input source menu.
   -- If a layout is not found, then the indicators are removed when that
   -- layout is active.
   colors = {
      -- Flag-like indicators
      Spanish = {col.green, col.white, col.red},
      German = {col.black, col.red, col.yellow},
      -- Contrived example of programmatically-generated colors
      -- ["U.S."] = (
      --    function() res={} 
      --       for i = 0,10,1 do
      --          table.insert(res, col.blue)
      --          table.insert(res, col.white)
      --          table.insert(res, col.red)
      --       end
      --       return res
      --    end)(),
      -- Solid colors
      --   Spanish = {col.red},
      --   German = {col.yellow},
   },
}

----------------------------------------------------------------------

local ind = nil

function initIndicators()
   if ind ~= nil then
      delIndicators()
   end
   ind = {}
end

function delIndicators()
   if ind ~= nil then
      for i,v in ipairs(ind) do
         if v ~= nil then
            v:delete()
         end
      end
      ind = nil
   end
end

--[[
   Get the output from the defaults command, extract the keyboard layout and call
   the provided callback with the layout name.

   Sample output expected in "out":
      (
              {
              InputSourceKind = "Keyboard Layout";
              "KeyboardLayout ID" = 0;
              "KeyboardLayout Name" = "U.S.";
          }
      )
--]]
function getInputSourceCallback(callback, code, out, err)
   task=nil
   if code == 0 then
      local _,layout = string.match(out, [["KeyboardLayout Name"%s*=%s*("?)(.-)%1;]])
      callback(layout)
   else
      logger.ef("getInputSourceCallback called with an error code %s, stdout='%s', stderr='%s'", code, out, err)
   end
end

-- Callback function will be called with the name of the currently-active keyboard layout
function passLayoutTo(callback)
   if task == nil then -- don't fire if there's already a task in progress
      task=tasks.new("/usr/bin/defaults", fn.partial(getInputSourceCallback, callback), {"read", os.getenv("HOME") .. "/Library/Preferences/com.apple.HIToolbox.plist", "AppleSelectedInputSources"})
      task:start()
   end
end

function drawIndicators(src)
   if src ~= prevlayout then
      initIndicators()

      def = mod.config.colors[src]
      logger.df("Indicator definition for %s: %s", src, hs.inspect(def))
      if def ~= nil then
         if mod.config.allScreens then
            screens = scr.allScreens()
         else
            screens = { scr.mainScreen() }
         end
         for i,screen in ipairs(screens) do
            local screeng = screen:fullFrame()
            local width = screeng.w / #def
            for i,v in ipairs(def) do
               if mod.config.indicatorHeight >= 0.0 and mod.config.indicatorHeight <= 1.0 then
                  height = mod.config.indicatorHeight*(screen:frame().y - screeng.y)
               else
                  height = mod.config.indicatorHeight
               end
               c = draw.rectangle(geom.rect(screeng.x+(width*(i-1)), screeng.y,
                                            width, height))
               c:setFillColor(v)
               c:setFill(true)
               c:setAlpha(mod.config.indicatorAlpha)
               c:setLevel(draw.windowLevels.overlay)
               c:setStroke(false)
               if mod.config.indicatorInAllSpaces then
                  c:setBehavior(draw.windowBehaviors.canJoinAllSpaces)
               end
               c:show()
               table.insert(ind, c)
            end
         end
      else
         logger.df("Removing indicators for %s because there is no color definitions for it.", src)
         delIndicators()
      end
   end

   prevlayout = src
end

function getLayoutAndDrawIndicators()
   passLayoutTo(drawIndicators)
end

function mod.init()
   if hs.task ~= nil then
      if mod.config.enableIndicator then
         initIndicators()

         -- Initial draw
         getLayoutAndDrawIndicators()
         -- Change whenever the input source changes
         keyc.inputSourceChanged(getLayoutAndDrawIndicators)
         if mod.config.enable_timer then
            logger.i("Enabling timer workaround for menubar indicator")
            timer = timers.new(mod.config.timer_frequency, getLayoutAndDrawIndicators)
            timer:start()
         end
      end
   else
      logger.w("Sorry, menubar_indicator needs hs.task, your version of Hammerspoon is too old")
   end
end

return mod
