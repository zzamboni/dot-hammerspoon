---- Skype stuff
---- Original code from https://github.com/cmsj/hammerspoon-config/blob/master/init.lua#L142

local mod={}

mod.config={
   skype_mute_key = {{"alt", "cmd", "ctrl", "shift"}, 'v'}
}
-- From https://github.com/cmsj/hammerspoon-config/blob/master/init.lua#L139

-- Toggle Skype between muted/unmuted, whether it is focused or not
function mod.toggleSkypeMute()
    local skype = hs.appfinder.appFromName("Skype")
    if not skype then
        return
    end

    local lastapp = nil
    if not skype:isFrontmost() then
        lastapp = hs.application.frontmostApplication()
        skype:activate()
    end

    if not skype:selectMenuItem({"Conversations", "Mute Microphone"}) then
        skype:selectMenuItem({"Conversations", "Unmute Microphone"})
    end

    if lastapp then
        lastapp:activate()
    end
end

function mod.init()
   hs.hotkey.bind(mod.config.skype_mute_key[1], mod.config.skype_mute_key[2], mod.toggleSkypeMute)
end

return mod
