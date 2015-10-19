-- Display a notification
function notify(title, message)
   hs.notify.new({title=title, informativeText=message}):send()
end

-- Store a string in the clipboard
function put_string_in_clipboard(str)
   hs.pasteboard.setContents(str)
end
