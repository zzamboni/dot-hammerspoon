--- Audio-related stuff

local spotify_was_playing = false

-- Testing the new audiodevice watcher
function audiowatch(arg)
   logger.df("Audiowatch arg: %s", arg)
end

hs.audiodevice.watcher.setCallback(audiowatch)
hs.audiodevice.watcher.start()

function spotify_pause()
   logger.df("Pausing Spotify")
   hs.spotify.pause()
end
function spotify_play()
   logger.df("Playing Spotify")
   hs.spotify.play()
end

-- Per-device watcher to detect headphones in/out
function audiodevwatch(dev_uid, event_name, event_scope, event_element)
   logger.df("Audiodevwatch args: %s, %s, %s, %s", dev_uid, event_name, event_scope, event_element)
   dev = hs.audiodevice.findDeviceByUID(dev_uid)
   if event_name == 'jack' then
      if dev:jackConnected() then
         if spotify_was_playing then
            spotify_play()
            notify("Headphones plugged", "Spotify restarted")
         end
      else
         -- Cache current state to know whether we should resume
         -- when the headphones are connected again
         spotify_was_playing = hs.spotify.isPlaying()
         if spotify_was_playing then
            spotify_pause()
            notify("Headphones unplugged", "Spotify paused")
         end
      end
   end
end

for i,dev in ipairs(hs.audiodevice.allOutputDevices()) do
   dev:watcherCallback(audiodevwatch):watcherStart()
   logger.df("Setting up watcher for audio device %s", dev:name())
end
