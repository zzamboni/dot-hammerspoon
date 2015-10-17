-- Display a sample of all the colors defines in hs.drawing.color

local swatches = nil

-- Algorithm from http://gamedev.stackexchange.com/a/38561/73496
function contrastingcolor(c)
   local gamma = 2.2;
   local L = 0.2126 * ( c.red^gamma ) + 0.7152 * ( c.green^gamma ) + 0.0722 * ( c.blue^gamma )
   if L>0.5 then
      return hs.drawing.color.black
   else
      return hs.drawing.color.white
   end
end

function colorsamples()
   local screen = hs.screen.mainScreen()
   local frame = screen:frame()
   
   if swatches ~= nil then
      for i,v in ipairs(swatches) do
         v:delete()
      end
      swatches = nil
   else
      swatches = {}
      keys = {}

      for k,v in pairs(hs.drawing.color) do table.insert(keys, k) end
      table.sort(keys)

      local rows = math.ceil(math.sqrt(#keys)*(frame.w/frame.h))
      local columns = math.ceil(math.sqrt(#keys)/(frame.w/frame.h))
      local hsize = math.floor(frame.w / columns)
      local vsize = math.floor(frame.h / rows)

      for i,k in ipairs(keys) do
         local v = hs.drawing.color[k]
         local column = math.floor((i-1)/rows)
         local row = i-1-(column*rows)
         local pos = hs.geometry.rect(frame.x+(column*hsize), frame.y+(row*vsize), hsize, vsize)
         local swatch = hs.drawing.rectangle(pos)
         swatch:setFill(true)
         swatch:setFillColor(v)
         swatch:setStroke(false)
         swatch:setLevel(hs.drawing.windowLevels.overlay)
         swatch:show()
         table.insert(swatches,swatch)
         local text = hs.drawing.text(pos, string.format("%s\n#%02x%02x%02x", k, math.floor(255*v.red), math.floor(255*v.green), math.floor(255*v.blue)))
         text:setTextColor(contrastingcolor(v))
         text:setTextStyle({ ["alignment"] = "center", ["size"]=16.0})
         text:setLevel(hs.drawing.windowLevels.overlay+1)
         text:show()
         table.insert(swatches,text)
      end
   end
end

-- Show/hide color samples
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "c",  colorsamples)
