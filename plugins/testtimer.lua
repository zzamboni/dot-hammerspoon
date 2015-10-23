local timer=hs.timer.new(hs.timer.seconds(5), function() hs.alert("Timer fired") end)
timer:start()
