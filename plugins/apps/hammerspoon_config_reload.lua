---- Configuration file management
---- Original code from http://www.hammerspoon.org/go/#fancyreload

local mod={}
local configFileWatcher = nil

mod.config = {
   auto_reload = true,
   manual_reload_key = {{"cmd", "alt", "ctrl"}, "r"}
}

-- Automatic config reload if any files in ~/.hammerspoon change
function reloadConfig(files)
   doReload = false
   for _,file in pairs(files) do
      if file:sub(-4) == ".lua" and (not string.match(file, '/[.]#')) then
         logger.df("Changed file = %s", file)
         doReload = true
      end
   end
   if doReload then
      hs.reload()
   end
end

function mod.init()
   if mod.config.auto_reload then
      logger.df("Setting up config auto-reload watcher on %s", hs_config_dir)
      configFileWatcher = hs.pathwatcher.new(hs_config_dir, reloadConfig)
      configFileWatcher:start()
   end

   -- Manual config reload
   omh.bind(mod.config.manual_reload_key, hs.reload)
end

return mod
