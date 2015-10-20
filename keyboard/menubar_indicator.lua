local as = require "hs.applescript"
local scr = require "hs.screen"
local draw = require "hs.drawing"
local geom = require "hs.geometry"
local col = draw.color

------- Functionality equivalent to ShowyEdge (https://pqrs.org/osx/ShowyEdge/index.html.en)

-- Global enable/disable
local enableIndicator = true
-- Display on all monitors or just the current one?
local allScreens = true
-- Specify 0.0-1.0 to specify a percentage of the height of the menu bar, larger values indicate a fixed height in pixels
local indicatorHeight = 1.0
-- transparency (1.0 - fully opaque)
local indicatorAlpha = 0.3
-- show the indicator in all spaces (this includes full-screen mode)
local indicatorInAllSpaces = true

---- Configuration of indicator colors

-- Each indicator is made of an arbitrary number of segments,
-- distributed evenly across the width of the screen. The table below
-- indicates the colors to use for a given keyboard layout. The index
-- is the name of the layout as it appears in the input source menu.
-- If a layout is not found, then the indicators are removed when that
-- layout is active.
local colors = {
   -- Flag-like indicators
   ["Spanish"] = {col.green, col.white, col.red},
   ["German"] = {col.black, col.red, col.yellow},
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
   --   ["Spanish"] = {col.red},
   --   ["German"] = {col.yellow},
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

function getInputSource()
   ok, result = as.applescript('tell application "System Events" to tell process "SystemUIServer" to get the value of the first menu bar item of menu bar 1 whose description is "text input"')
   if ok then
      return result
   else
      return nil
   end
end

function drawIndicators(src)
   initIndicators()

   def = colors[src]
   logger.df("Indicator definition for %s: %s", src, hs.inspect(def))
   if def ~= nil then
      if allScreens then
         screens = scr.allScreens()
      else
         screens = { scr.mainScreen() }
      end
      for i,screen in ipairs(screens) do
         local screeng = screen:fullFrame()
         local width = screeng.w / #def
         for i,v in ipairs(def) do
            if indicatorHeight >= 0.0 and indicatorHeight <= 1.0 then
               height = indicatorHeight*(screen:frame().y - screeng.y)
            else
               height = indicatorHeight
            end
            c = draw.rectangle(geom.rect(screeng.x+(width*(i-1)), screeng.y,
                                         width, height))
            c:setFillColor(v)
            c:setFill(true)
            c:setAlpha(indicatorAlpha)
            c:setLevel(draw.windowLevels.overlay)
            c:setStroke(false)
            if indicatorInAllSpaces then
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

function inputSourceChange()
   source = getInputSource()
   logger.df("New input source: " .. source)
   drawIndicators(source)
end

if enableIndicator then
   initIndicators()

   -- Initial draw
   drawIndicators(getInputSource())
   -- Change whenever the input source changes
   hs.keycodes.inputSourceChanged(inputSourceChange)
end
