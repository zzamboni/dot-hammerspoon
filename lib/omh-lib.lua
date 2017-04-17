local omh={}

-- Some useful global variables
omh.logger = hs.logger.new('omh')

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

-- Bind a key, simply a bridge between the OMH config format and hs.hotkey.bind
-- keyspec is { { modifiers }, key }
function omh.bind(keyspec, fun, desc)
   if (keyspec ~= nil) and (keyspec[1] ~= nil) and (keyspec[2] ~= nil) and (fun ~= nil) then
      hs.hotkey.bind(keyspec[1], keyspec[2], fun)
   end
end

-- Sleep for (possibly fractional) number of seconds
local clock = os.clock
function omh.sleep(n)  -- seconds
   local t0 = clock()
   while clock() - t0 <= n do end
end

return omh
