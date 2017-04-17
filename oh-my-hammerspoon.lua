package.path = package.path .. ';lib/?.lua;plugins/?.lua'

-- Global variable so all modules can use it automatically
omh=require("omh-lib")

omh.plugin={}
local OMH_PLUGINS={}
local OMH_CONFIG={}

function omh.load_plugins(plugins)
   plugins = plugins or {}
   for i,p in ipairs(plugins) do
      table.insert(OMH_PLUGINS, p)
   end
   for i,plugin in ipairs(OMH_PLUGINS) do
      omh.logger.df("Loading plugin %s", plugin)
      -- First, load the plugin
      mod = require(plugin)
      -- If it returns a table (like a proper module should), then
      -- we may be able to access additional functionality
      if type(mod) == "table" then
         -- If the user has specified some config parameters, merge
         -- them with the module's 'config' element (creating it
         -- if it doesn't exist)
         if OMH_CONFIG[plugin] ~= nil then
            if mod.config == nil then
               mod.config = {}
            end
            for k,v in pairs(OMH_CONFIG[plugin]) do
               mod.config[k] = v
            end
         end
         -- If it has an init() function, call it
         if type(mod.init) == "function" then
            omh.logger.i(string.format("Initializing plugin %s", plugin))
            mod.init()
         end
      end
      -- Cache the module
      omh.plugin[plugin] = mod
   end
end

-- Specify config parameters for a plugin. First name
-- is the name as specified in OMH_PLUGINS, second is a table.
function omh.config(name, config)
   omh.logger.df("omh.config, name=%s, config=%s", name, hs.inspect(config))
   OMH_CONFIG[name]=config
end

-- Load and configure the plugins
function omh.go(plugins)
   omh.load_plugins(plugins)
end

function omh.list(verbose)
   -- List loaded plugins, to be used as a value for the `process` option of `inspect()`
   local remove_internal_fields = function(item, path)
      if path[#path] ~= hs.inspect.KEY and string.match(path[#path] or "", '^_') then
         return "<skipped>"
      else
         return item
      end
   end
   print("Oh-my-hammerspoon: the following plugins are loaded:")
   for k,v in pairs(omh.plugin) do
      print("- " .. k)
      if verbose and type(v) == "table" and v.config ~= nil then
         print("\n    " .. hs.inspect(v.config, {newline="\n    ", process=remove_internal_fields}) .. "\n")
      end
   end
end

-- Load local code if it exists
local status, err = pcall(function() require("init-local") end)
if not status then
   -- A 'no file' error is OK, but anything else needs to be reported
   if string.find(err, 'no file') == nil then
      error(err)
   end
end

---- Notify when the configuration is loaded
omh.notify("Welcome to Oh my Hammerspoon!", "Have fun!")

return omh
