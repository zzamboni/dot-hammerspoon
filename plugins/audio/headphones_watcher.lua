--- Pause/unpause playing music
---- Diego Zamboni <diego@zzamboni.org>
--- Needs Hammerspoon built with audio-device watcher capabilities (not released yet)

local mod={}

mod.config={
   ["control_spotify"] = true,
   ["control_itunes"]  = true,
}

local spotify=require("hs.spotify")
local itunes=require("hs.itunes")
local audio=require("hs.audiodevice")

local spotify_was_playing = false
local itunes_was_playing = false

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
         logger.d("Headphones connected")
         if mod.config.control_spotify and spotify_was_playing then
            logger.d("Playing Spotify")
            notify("Headphones plugged", "Playing Spotify")
            spotify.play()
         end
         if mod.config.control_itunes and itunes_was_playing then
            logger.d("Playing iTunes")
            notify("Headphones plugged", "Playing iTunes")
            itunes.play()
         end
      else
         logger.d("Headphones disconnected")
         -- Cache current state to know whether we should resume
         -- when the headphones are connected again
         spotify_was_playing = spotify.isPlaying()
         logger.df("spotify_was_playing=%s", spotify_was_playing)
         itunes_was_playing = itunes.isPlaying()
         logger.df("itunes_was_playing=%s", itunes_was_playing)
         if mod.config.control_spotify and spotify_was_playing then
            logger.d("Pausing Spotify")
            notify("Headphones unplugged", "Pausing Spotify")
            spotify.pause()
         end
         if mod.config.control_itunes and itunes_was_playing then
            logger.d("Pausing iTunes")
            notify("Headphones unplugged", "Pausing iTunes")
            itunes.pause()
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
