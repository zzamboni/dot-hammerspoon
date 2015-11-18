--- Pause/unpause playing music
---- Diego Zamboni <diego@zzamboni.org>
--- Needs Hammerspoon with audio-device watcher capabilities
--- (0.9.43 or later), but checks for the features so it won't crash.

local mod={}

mod.config={
   control_spotify = true,
   control_itunes  = true,
}

local spotify=require("hs.spotify")
local itunes=require("hs.itunes")
local audio=require("hs.audiodevice")

local spotify_was_playing = false
local itunes_was_playing = false

local devs = {}

-- Per-device watcher to detect headphones in/out
function audiodevwatch(dev_uid, event_name, event_scope, event_element)
   logger.df("Audiodevwatch args: %s, %s, %s, %s", dev_uid, event_name, event_scope, event_element)
   dev = audio.findDeviceByUID(dev_uid)
   if event_name == 'jack' then
      if dev:jackConnected() then
         logger.d("Headphones connected")
         if mod.config.control_spotify and spotify_was_playing then
            logger.d("Resuming playback in Spotify")
            notify("Headphones plugged", "Resuming Spotify playback")
            spotify.play()
         end
         if mod.config.control_itunes and itunes_was_playing then
            logger.d("Resuming playback in iTunes")
            notify("Headphones plugged", "Resuming iTunes playback")
            itunes.play()
         end
      else
         logger.d("Headphones disconnected")
         -- Cache current state to know whether we should resume
         -- when the headphones are connected again
         spotify_was_playing = spotify.isPlaying()
         itunes_was_playing = itunes.isPlaying()
         logger.df("spotify_was_playing=%s", spotify_was_playing)
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
      if dev.watcherCallback ~= nil then
         logger.df("Setting up watcher for audio device %s (UID %s)", dev:name(), dev:uid())
         devs[dev:uid()]=dev:watcherCallback(audiodevwatch)
         devs[dev:uid()]:watcherStart()
      else
         logger.w("Skipping audio device watcher setup because you have an older version of Hammerspoon")
      end
   end
end

return mod
