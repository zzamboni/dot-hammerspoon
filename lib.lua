-- Display a notification
function notify(title, message)
   hs.notify.new({title=title, informativeText=message}):send()
end
