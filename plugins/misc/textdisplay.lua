--- Display arbitrary ANSI-colored text

mod = {}

mod.config = {
   commands = {
      {
         command = "top-open-fds.pl",
         args = { "-color" },
         frame = hs.geometry.rect(10,10,500,500),
         -- frequency = 60, -- default
         -- level = hs.drawing.windowLevels.desktop, -- default
         attributes = 
   },
   strings = {
      {
         string = "hi there",
         frame = hs.geometry.rect(600,10,500,500),
         --level = hs.drawing.windowLevels.desktop, -- default
      }
   }
}

function mod.init()
   -- First draw the static strings
   for i,v in ipairs(mod.config.strings) do
      local str = v.string
      local fr  = v.frame
      local lv  = v.level or hs.drawing.windowLevels.desktop
      
   end
end

return mod
