--- Color picker
---- Diego Zamboni <diego@zzamboni.org>

-- Display a sample/picker of all the colors defined in hs.drawing.color
-- (or any other color table, see the binding at the end).
-- The same keybinding toggles the color display. Clicking on any color
-- will copy its name to the clipboard, cmd-click will copy its RGB code.

local mod={}

require("omh-lib")

local draw = require('hs.drawing')
local scr  = require('hs.screen')
local geom = require('hs.geometry')
local tap  = require('hs.eventtap')
local choosermenu = nil
local have_colorlists = false
if type(hs.drawing.color.lists) == "function" then
   have_colorlists = true
end

mod.config={
   colorpicker_key = { {"ctrl", "alt", "cmd"}, "c" },
   colorpicker_in_menubar = true,
   colorpicker_menubar_title = "\u{1F308}", -- Rainbow Emoji: http://emojipedia.org/rainbow/
   colorpicker_individual_table_keys = false,
   colortable_keys = {
      x11 =         { draw.color.x11, {"ctrl", "alt", "cmd"}, "x" },
      hammerspoon = { draw.color.hammerspoon, {"ctrl", "alt", "cmd"}, "h" },
      ansi =        { draw.color.ansiTerminalColors, {"ctrl", "alt", "cmd"}, "a" }
   }
}

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
function contrastingColor(color)
   local black = { red=0.000,green=0.000,blue=0.000,alpha=1 }
   local white = { red=1.000,green=1.000,blue=1.000,alpha=1 }
   local c=color
   if have_colorlists then
      c=draw.color.asRGB(color)
   end
   if type(c) == "table" then
      local L = 0.2126*(c.red*c.red) + 0.7152*(c.green*c.green) + 0.0722*(c.blue*c.blue)
      if L>0.5 then
         return black
      else
         return white
      end
   else
      return black
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
function drawSwatch(tablename, swatchFrame, colorname, col)
   local swatch = draw.rectangle(swatchFrame)
   swatch:setFill(true)
   swatch:setFillColor(col)
   swatch:setStroke(false)
   swatch:setLevel(draw.windowLevels.overlay)
   swatch:show()
   table.insert(swatches[tablename], swatch)
   if colorname ~= "" then
      color=col
      if have_colorlists then
         color=draw.color.asRGB(col)
      end
      local hex
      if type(color) == "table" then
         hex = "#" .. string.format("%02x%02x%02x", math.floor(255*color.red), math.floor(255*color.green), math.floor(255*color.blue))
      else
         hex = ""
      end
      local text
      if have_colorlists then
         local str = hs.styledtext.new(string.format("%s\n%s", colorname, hex), { paragraphStyle = {alignment = "center"}, font={size=16.0}, color=contrastingColor(col) } )
         text = hs.drawing.text(swatchFrame, str)
      else
         text = draw.text(swatchFrame, string.format("%s\n#%s", colorname, hex))
         text:setTextColor(contrastingColor(color))
         text:setTextStyle({ alignment = "center", size=16.0})
      end
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
      -- Create sorted list of colors
      keys = sortedkeys(colortable)

      -- Scale number of rows/columns according to the screen's aspect ratio
      local rows = math.floor(math.sqrt(#keys)*(frame.w/frame.h))
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
            local gray = { red=0.500,green=0.500,blue=0.500,alpha=1 }
            drawSwatch(tablename,swatchFrame,"",gray)
         end
      end
      indicators_shown = true
   end
end

function mod.choosetable()
   local tab={}
   local lists=draw.color.lists()
   local keys=sortedkeys(lists)
   for i,v in ipairs(keys) do
      table.insert(tab, {title = v, fn = hs.fnutils.partial(toggleColorSamples, v, lists[v])})
   end
   return tab
end

function mod.init()
   -- Show/hide color samples
   -- Change the table and tablename if you want to handle multiple color tables
   if have_colorlists then
      if mod.config.colorpicker_individual_table_keys then
         for k,v in pairs(mod.config.colortable_keys) do
            hs.hotkey.bind(v[2], v[3], hs.fnutils.partial(toggleColorSamples,  k, v[1]))
         end
      end
      choosermenu = hs.menubar.new(mod.config.colorpicker_in_menubar)
      choosermenu:setTitle(mod.config.colorpicker_menubar_title)
      choosermenu:setMenu(mod.choosetable)
      hs.hotkey.bind(mod.config.colorpicker_key[1], mod.config.colorpicker_key[2], function() choosermenu:popupMenu(hs.mouse.getAbsolutePosition()) end)
   else
      hs.hotkey.bind(mod.config.colorpicker_key[1], mod.config.colorpicker_key[2], hs.fnutils.partial(toggleColorSamples, "default", hs.drawing.color))
   end
end

return mod
