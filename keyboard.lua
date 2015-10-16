local as = require "hs.applescript"
local scr = require "hs.screen"
local draw = require "hs.drawing"
local geom = require "hs.geometry"
local col = draw.color

-- Add colors missing from hs.drawing.color (should submit pull request soon)
col["yellow"] = { ["red"]=1.000,["green"]=1.000,["blue"]=0.000,["alpha"]=1 }

------- Functionality equivalent to ShowyEdge (https://pqrs.org/osx/ShowyEdge/index.html.en)

---- Configuration of indicator colors
-- Each indicator is made of three segments, distributed evenly across the width of
-- the screen. The table below indicates the color of each segment for a given keyboard
-- layout. The index is the name of the layout as it appears in the input source menu.
-- If a layout is not found, then the indicators are removed when that layout is active.
-- (e.g. U.S. does not appear because it's my default and I don't want any indicators)
local colors = {
   ["Spanish"] = {col.red, col.yellow, col.red},
   ["German"] = {col.black, col.red, col.yellow},
}
local indicatorHeight = 7
local indicatorAlpha = 0.3
local indicatorInAllSpaces = true

----------------------------------------------------------------------

local ind = nil

function initIndicators()
   if ind ~= nil then
      delIndicators()
   end
   ind = {}
   local screeng = scr.mainScreen():fullFrame()
   local width = screeng.w / 3
   for i = 1,3,1 do
      ind[i] = draw.rectangle(geom.rect(screeng.x+(width*(i-1)), screeng.y,
                                        width, indicatorHeight))
   end
end

function delIndicators()
   if ind ~= nil then
      for i = 1,3,1 do
         if ind[i] ~= nil then
            ind[i]:delete()
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

   c = colors[src]
   logger.df("Indicator definition for %s: %s", src, hs.inspect(c))
   if c ~= nil then
      for i = 1,3,1 do
         ind[i]:setFillColor(c[i])
         ind[i]:setFill(true)
         ind[i]:setAlpha(indicatorAlpha)
         ind[i]:setLevel(draw.windowLevels.overlay)
         ind[i]:setStroke(false)
         if indicatorInAllSpaces then
            ind[i]:setBehavior(draw.windowBehaviors.canJoinAllSpaces)
         end
         ind[i]:show()
      end
   else
      logger.df("Removing indicators for %s because there is no color definitions for it.", src)
      for i = 1,3,1 do
         ind[i]:delete()
      end
   end

end

function inputSourceChange()
   source = getInputSource()
   logger.df("New input source: " .. source)
   drawIndicators(source)
end

initIndicators()

-- Initial draw
drawIndicators(getInputSource())
-- Change whenever the input source changes
hs.keycodes.inputSourceChanged(inputSourceChange)
