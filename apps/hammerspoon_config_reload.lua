---- Configuration file management

-- Manual config reload
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", hs.reload)

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

hs.pathwatcher.new(hs_config_dir, reloadConfig):start()

---- Notify when the configuration is loaded
notify("Hammerspoon", "Config loaded")
