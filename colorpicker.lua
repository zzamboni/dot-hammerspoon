-- Display a sample/picker of all the colors defined in hs.drawing.color
-- (or any other color table, see the binding at the end).
-- The same keybinding toggles the color display. Clicking on any color
-- will copy its name to the clipboard, cmd-click will copy its RGB code.

local draw = require('hs.drawing')
local scr  = require('hs.screen')
local geom = require('hs.geometry')
local tap  = require('hs.eventtap')

-- This is where the drawing objects are stored. After first use, the
-- created objects are cached (only shown/hidden as needed) so that
-- they are shown much faster in future uses.
-- toggleColorSamples() can handle multiple color tables at once,
-- so these global caches are tables.
local swatches = {}

-- Are the indicators displayed at the moment?
local indicators_shown = {}

-- Algorithm to choose whether white/black as the most contrasting to a given
-- color, from http://gamedev.stackexchange.com/a/38561/73496
function contrastingColor(c)
   local L = 0.2126*(c.red*c.red) + 0.7152*(c.green*c.green) + 0.0722*(c.blue*c.blue)
   local black = { ["red"]=0.000,["green"]=0.000,["blue"]=0.000,["alpha"]=1 }
   local white = { ["red"]=1.000,["green"]=1.000,["blue"]=1.000,["alpha"]=1 }
   if L>0.5 then
      return black
   else
      return white
   end
end

-- Get the frame for a single swatch
function getSwatchFrame(frame, hsize, vsize, column, row)
   return geom.rect(frame.x+(column*hsize), frame.y+(row*vsize), hsize, vsize)
end

-- Copy the name/code of the color to the clipboard, and remove the colors
-- from the screen.
function copyAndRemove(name, hex, tablename)
   local mods = tap.checkKeyboardModifiers()
   if mods.cmd then
      hs.pasteboard.setContents(hex)
   else
      hs.pasteboard.setContents(name)
   end
   toggleColorSamples(tablename)
end

-- Draw a single square on the screen
function drawSwatch(tablename, swatchFrame, colorname, color)
   local swatch = draw.rectangle(swatchFrame)
   swatch:setFill(true)
   swatch:setFillColor(color)
   swatch:setStroke(false)
   swatch:setLevel(draw.windowLevels.overlay)
   swatch:show()
   table.insert(swatches[tablename], swatch)
   if colorname ~= "" then
      local hex = string.format("%02x%02x%02x", math.floor(255*color.red), math.floor(255*color.green), math.floor(255*color.blue))
      local text = draw.text(swatchFrame, string.format("%s\n#%s", colorname, hex))
      text:setTextColor(contrastingColor(color))
      text:setTextStyle({ ["alignment"] = "center", ["size"]=16.0})
      text:setLevel(draw.windowLevels.overlay+1)
      text:setClickCallback(nil, hs.fnutils.partial(copyAndRemove, colorname, hex, tablename))
      text:show()
      table.insert(swatches[tablename],text)
   end
end

-- Toggle display on the screen of a grid with all the colors in the given colortable
function toggleColorSamples(tablename, colortable)
   local screen = scr.mainScreen()
   local frame = screen:frame()
   
   if swatches[tablename] ~= nil then  -- they are being displayed, remove them
      for i,color in ipairs(swatches[tablename]) do
         if indicators_shown then
            color:hide()
         else
            color:show()
         end
      end
      indicators_shown = not indicators_shown
   else  -- display them
      swatches[tablename] = {}
      keys = {}

      -- Create sorted list of colors
      for colorname,color in pairs(colortable) do table.insert(keys, colorname) end
      table.sort(keys)

      -- Scale number of rows/columns according to the screen's aspect ratio
      local rows = math.ceil(math.sqrt(#keys)*(frame.w/frame.h))
      local columns = math.ceil(math.sqrt(#keys)/(frame.w/frame.h))
      local hsize = math.floor(frame.w / columns)
      local vsize = math.floor(frame.h / rows)

      for i = 1,(rows*columns),1 do   -- fill the entire square
         local colorname = keys[i]
         local column = math.floor((i-1)/rows)
         local row = i-1-(column*rows)
         local swatchFrame = getSwatchFrame(frame,hsize,vsize,column,row)
         if colorname ~= nil then     -- with the corresponding color swatch
            local color = colortable[colorname]
            drawSwatch(tablename,swatchFrame,colorname,color)
         else  -- or with a gray swatch to fill up the rectangle
            drawSwatch(tablename,swatchFrame,"",draw.color.gray)
         end
      end
      indicators_shown = true
   end
end

-- Show/hide color samples
-- Change the table and tablename if you want to handle multiple color tables
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "c",  hs.fnutils.partial(toggleColorSamples,  "default", draw.color))
