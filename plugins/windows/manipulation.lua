-- Window management
--- Diego Zamboni <diego@zzamboni.org>

local winmod = {}

winmod.config = {
   left_half   = { {"ctrl",        "cmd"}, "Left" },
   right_half  = { {"ctrl",        "cmd"}, "Right" },
   top_half    = { {"ctrl",        "cmd"}, "Up" },
   bottom_half = { {"ctrl",        "cmd"}, "Down" },
   third_left  = { {"ctrl", "alt"       }, "Left" },
   third_right = { {"ctrl", "alt"       }, "Right" },
   third_up    = { {"ctrl", "alt"       }, "Up" },
   third_down  = { {"ctrl", "alt"       }, "Down" },
   max_toggle  = { {"ctrl", "alt", "cmd"}, "F" },
   max         = { {"ctrl", "alt", "cmd"}, "Up" },
   screen_left = { {"ctrl", "alt", "cmd"}, "Left" },
   screen_right= { {"ctrl", "alt", "cmd"}, "Right" },
}

-- Window cache for window maximize toggler
local frameCache = {}

----------------------------------------------------------------------
--- Base window resizing and moving functions
----------------------------------------------------------------------

-- Resize current window to different parts of the screen
function winmod.resizeCurrentWindow(how)
   local win = hs.window.focusedWindow()
   if win == nil then
      return
   end
   local app = win:application():name()
   local windowLayout
   local newrect

   if how == "left" then
      newrect = hs.layout.left50
   elseif how == "right" then
      newrect = hs.layout.right50
   elseif how == "top" then
      newrect = {0,0,1,0.5}
   elseif how == "bottom" then
      newrect = {0,0.5,1,0.5}
   elseif how == "max" then
      newrect = hs.layout.maximized
   elseif how == "left_third" or how == "hthird-0" then
      newrect = {0,0,1/3,1}
   elseif how == "middle_third_h" or how == "hthird-1" then
      newrect = {1/3,0,1/3,1}
   elseif how == "right_third" or how == "hthird-2" then
      newrect = {2/3,0,1/3,1}
   elseif how == "top_third" or how == "vthird-0" then
      newrect = {0,0,1,1/3}
   elseif how == "middle_third_v" or how == "vthird-1" then
      newrect = {0,1/3,1,1/3}
   elseif how == "bottom_third" or how == "vthird-2" then
      newrect = {0,2/3,1,1/3}
   end

   win:move(newrect)
end

-- Move current window to a different screen
function winmod.moveCurrentWindowToScreen(how)
   local win = hs.window.focusedWindow()
   if win == nil then
      return
   end
   hs.window.setFrameCorrectness = true
   if how == "left" then
      win:moveOneScreenWest()
   elseif how == "right" then
      win:moveOneScreenEast()
   end
   hs.window.setFrameCorrectness = false
end

-- Toggle current window between its normal size, and being maximized
function winmod.toggleMaximized()
   local win = hs.window.focusedWindow()
   if (win == nil) or (win:id() == nil) then
      return
   end
   if frameCache[win:id()] then
      win:setFrame(frameCache[win:id()])
      frameCache[win:id()] = nil
   else
      frameCache[win:id()] = win:frame()
      win:maximize()
   end
end

-- Get the horizontal third of the screen in which a window is at the moment
function get_horizontal_third(win)
   if win == nil then
      return
   end
   local frame=win:frame()
   local screenframe=win:screen():frame()
   local relframe=hs.geometry(frame.x-screenframe.x, frame.y-screenframe.y, frame.w, frame.h)
   local third = math.floor(3.01*relframe.x/screenframe.w)
   logger.df("Screen frame: %s", screenframe)
   logger.df("Window frame: %s, relframe %s is in horizontal third #%d", frame, relframe, third)
   return third
end

-- Get the vertical third of the screen in which a window is at the moment
function get_vertical_third(win)
   if win == nil then
      return
   end
   local frame=win:frame()
   local screenframe=win:screen():frame()
   local relframe=hs.geometry(frame.x-screenframe.x, frame.y-screenframe.y, frame.w, frame.h)
   local third = math.floor(3.01*relframe.y/screenframe.h)
   logger.df("Screen frame: %s", screenframe)
   logger.df("Window frame: %s, relframe %s is in vertical third #%d", frame, relframe, third)
   return third
end

----------------------------------------------------------------------
--- Shortcut functions for those above
----------------------------------------------------------------------

function winmod.leftHalf()
   winmod.resizeCurrentWindow("left")
end

function winmod.rightHalf()
   winmod.resizeCurrentWindow("right")
end

function winmod.topHalf()
   winmod.resizeCurrentWindow("top")
end

function winmod.bottomHalf()
   winmod.resizeCurrentWindow("bottom")
end

function winmod.maximize()
   hs.window.setFrameCorrectness = true
   winmod.resizeCurrentWindow("max")
   hs.window.setFrameCorrectness = false
end

function winmod.oneThirdLeft()
   local win = hs.window.focusedWindow()
   if win == nil then
      return
   end
   local third = get_horizontal_third(win)
   winmod.resizeCurrentWindow("hthird-" .. math.max(third-1,0))
end

function winmod.oneThirdRight()
   local win = hs.window.focusedWindow()
   if win == nil then
      return
   end
   local third = get_horizontal_third(win)
   winmod.resizeCurrentWindow("hthird-" .. math.min(third+1,2))
end

function winmod.oneThirdUp()
   local win = hs.window.focusedWindow()
   if win == nil then
      return
   end
   local third = get_vertical_third(win)
   winmod.resizeCurrentWindow("vthird-" .. math.max(third-1,0))
end

function winmod.onethirdDown()
   local win = hs.window.focusedWindow()
   if win == nil then
      return
   end
   local third = get_vertical_third(win)
   winmod.resizeCurrentWindow("vthird-" .. math.min(third+1,2))
end

function winmod.oneScreenLeft()
   winmod.moveCurrentWindowToScreen("left")
end

function winmod.oneScreenRight()
   winmod.moveCurrentWindowToScreen("right")
end

--- Assign key bindings

function winmod.bindKeys()
   -------- Key bindings
   local c=winmod.config

   -- Halves of the screen
   omh.bind(c.left_half, winmod.leftHalf)
   omh.bind(c.right_half, winmod.rightHalf)
   omh.bind(c.top_half, winmod.topHalf)
   omh.bind(c.bottom_half, winmod.bottomHalf)
                                                        
   -- Thirds of the screen                              
   omh.bind(c.third_left, winmod.oneThirdLeft)
   omh.bind(c.third_right, winmod.oneThirdRight)
   omh.bind(c.third_up, winmod.oneThirdUp)
   omh.bind(c.third_down, winmod.onethirdDown)
                                                        
   -- Maximized                                         
   omh.bind(c.max_toggle, winmod.toggleMaximized)
   omh.bind(c.max, winmod.maximize)
                                                        
   -- Move between screens                              
   omh.bind(c.screen_left, winmod.oneScreenLeft)
   omh.bind(c.screen_right, winmod.oneScreenRight)
end

--- Initialize the module
function winmod.init()
   winmod.bindKeys()
end

return winmod
