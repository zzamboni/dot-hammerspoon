local omh={}

-- Some useful global variables
hostname = hs.host.localizedName()
logger = hs.logger.new('oh-my-hs')
hs_config_dir = os.getenv("HOME") .. "/.hammerspoon/"

-- Display a notification
function omh.notify(title, message)
   hs.notify.new({title=title, informativeText=message}):send()
end

-- Return the sorted keys of a table
function omh.sortedkeys(tab)
   local keys={}
   -- Create sorted list of keys
   for k,v in pairs(tab) do table.insert(keys, k) end
   table.sort(keys)
   return keys
end

-- Reimplemented version of capture() because sometimes Lua
-- fails with "interrupted system call" when using io.popen() on OS X
-- This is ugly, don't use it! Better use hs.task
function omh.capture(cmd, raw)
   local tmpfile = os.tmpname()
   os.execute(cmd .. ">" .. tmpfile)
   local f=io.open(tmpfile)
   local s=f:read("*a")
   f:close()
   os.remove(tmpfile)
   if raw then return s end
   s = string.gsub(s, '^%s+', '')
   s = string.gsub(s, '%s+$', '')
   s = string.gsub(s, '[\n\r]+', ' ')
   return s
end

-- Bind a key, simply a bridge between the OMH config format and hs.hotkey.bind
-- keyspec is { { modifiers }, key }
function omh.bind(keyspec, fun)
   hs.hotkey.bind(keyspec[1], keyspec[2], fun)
end

-- Sleep for (possibly fractional) number of seconds
local clock = os.clock
function omh.sleep(n)  -- seconds
   local t0 = clock()
   while clock() - t0 <= n do end
end

return omh
