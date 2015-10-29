---- Configuration file management
local mod={}

mod.config = {
   ["auto_reload"]=true,
   ["manual_reload_key"]={{"cmd", "alt", "ctrl"}, "R"}
}

-- Automatic config reload if any files in ~/.hammerspoon change
function reloadConfig(files)
   doReload = false
   for _,file in pairs(files) do
      if file:sub(-4) == ".lua" then
         doReload = true
      end
   end
   if doReload then
      hs.reload()
   end
end

function mod.init()
   if mod.config.auto_reload then
      hs.pathwatcher.new(hs_config_dir, reloadConfig):start()
   end

   -- Manual config reload
   if type(mod.config.manual_reload_key) == "table" then
      hs.hotkey.bind(mod.config.manual_reload_key[1], mod.config.manual_reload_key[2], hs.reload)
   end
end

return mod
