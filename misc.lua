-- Display a sample of all the colors defines in hs.drawing.color

local swatches = nil

local draw = require('hs.drawing')
local scr  = require('hs.screen')
local geom = require('hs.geometry')

-- Algorithm to choose whether white/black as the most contrasting to a given
-- color, from http://gamedev.stackexchange.com/a/38561/73496
function contrastingcolor(c)
   local L = 0.2126 * ( c.red*c.red ) + 0.7152 * ( c.green*c.green ) + 0.0722 * ( c.blue*c.blue )
   if L>0.5 then
      return draw.color.black
   else
      return draw.color.white
   end
end

-- Get the frame for a single swatch
function getframe(frame, hsize, vsize, column, row)
   return geom.rect(frame.x+(column*hsize), frame.y+(row*vsize), hsize, vsize)
end

-- Draw a single square on the screen
function drawswatch(frame, colorname, color, hsize, vsize, column, row)
   local pos = getframe(frame,hsize,vsize,column,row)
   local swatch = draw.rectangle(pos)
   swatch:setFill(true)
   swatch:setFillColor(color)
   swatch:setStroke(false)
   swatch:setLevel(draw.windowLevels.overlay)
   swatch:show()
   table.insert(swatches, swatch)
   if colorname ~= "" then
      local text = draw.text(pos, string.format("%s\n#%02x%02x%02x", colorname, math.floor(255*color.red), math.floor(255*color.green), math.floor(255*color.blue)))
      text:setTextColor(contrastingcolor(color))
      text:setTextStyle({ ["alignment"] = "center", ["size"]=16.0})
      text:setLevel(draw.windowLevels.overlay+1)
      text:show()
      table.insert(swatches,text)
   end
end

-- Toggle display on the screen of a grid with all the colors in the given colortable
function colorsamples(colortable)
   local screen = scr.mainScreen()
   local frame = screen:frame()
   
   if swatches ~= nil then  -- they are being displayed, remove them
      for i,color in ipairs(swatches) do
         color:delete()
      end
      swatches = nil
   else  -- display them
      swatches = {}
      keys = {}

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
         if colorname ~= nil then     -- with the corresponding color swatch
            local color = colortable[colorname]
            drawswatch(frame,colorname,color,hsize,vsize,column,row)
         else  -- or with a gray swatch to fill up the rectangle
            drawswatch(frame,"",draw.color.gray,hsize,vsize,column,row)
         end
      end
   end
end

-- Show/hide color samples
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "c",  hs.fnutils.partial(colorsamples, draw.color))
