-- Some useful global variables
hostname = hs.host.localizedName()
logger = hs.logger.new('oh-my-hs')
hs_config_dir = os.getenv("HOME") .. "/.hammerspoon/"

-- Display a notification
function notify(title, message)
   hs.notify.new({title=title, informativeText=message}):send()
end

-- Algorithm to choose whether white/black as the most contrasting to a given
-- color, from http://gamedev.stackexchange.com/a/38561/73496
function chooseContrastingColor(c)
   local L = 0.2126*(c.red*c.red) + 0.7152*(c.green*c.green) + 0.0722*(c.blue*c.blue)
   local black = { ["red"]=0.000,["green"]=0.000,["blue"]=0.000,["alpha"]=1 }
   local white = { ["red"]=1.000,["green"]=1.000,["blue"]=1.000,["alpha"]=1 }
   if L>0.5 then
      return black
   else
      return white
   end
end

-- Return the sorted keys of a table
function sortedkeys(tab)
   local keys={}
   -- Create sorted list of keys
   for k,v in pairs(tab) do table.insert(keys, k) end
   table.sort(keys)
   return keys
end

-- Capture command output
-- From http://stackoverflow.com/a/326715/5562
function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end
