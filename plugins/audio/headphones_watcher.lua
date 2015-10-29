--- Pause/unpause playing music

local mod={}

local spotify=require("hs.spotify")
local audio=require("hs.audiodevice")

local spotify_was_playing = false

-- Testing the new audiodevice watcher
--[[
function audiowatch(arg)
   logger.df("Audiowatch arg: %s", arg)
end

audio.watcher.setCallback(audiowatch)
audio.watcher.start()
--]]

-- Per-device watcher to detect headphones in/out
function audiodevwatch(dev_uid, event_name, event_scope, event_element)
   logger.df("Audiodevwatch args: %s, %s, %s, %s", dev_uid, event_name, event_scope, event_element)
   dev = audio.findDeviceByUID(dev_uid)
   if event_name == 'jack' then
      if dev:jackConnected() then
         if spotify_was_playing then
            notify("Headphones plugged", "Playing Spotify")
            spotify.play()
         end
      else
         -- Cache current state to know whether we should resume
         -- when the headphones are connected again
         spotify_was_playing = spotify.isPlaying()
         if spotify_was_playing then
            notify("Headphones unplugged", "Pausing Spotify")
            spotify.pause()
         end
      end
   end
end

function mod.init()
   for i,dev in ipairs(audio.allOutputDevices()) do
      dev:watcherCallback(audiodevwatch):watcherStart()
      logger.df("Setting up watcher for audio device %s", dev:name())
   end
end

return mod
