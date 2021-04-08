local win = hs.window.frontmostWindow()
local o,s,t,r = hs.execute("~/.emacs.d/bin/org-capture", true)
if not s then
  print("Error when running org-capture: "..o.."\n")
end
win:focus()
