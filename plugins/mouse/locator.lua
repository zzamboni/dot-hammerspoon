--- Find my mouse pointer
---- Original code from https://github.com/cmsj/hammerspoon-config/blob/master/init.lua#L428

local mod={}

mod.config={
   color = {red=1,blue=0,green=0,alpha=1},
   linewidth = 5,
   diameter = 80,
   mouse_locate_key = { {"cmd","alt","ctrl"}, "D" }
}

local mouseCircle = nil
local mouseCircleTimer = nil

function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition ()
    -- Prepare a big red circle around the mouse pointer
    local diameter = mod.config.diameter
    local radius = math.floor(diameter / 2)
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-radius, mousepoint.y-radius, diameter, diameter))
    mouseCircle:setStrokeColor(mod.config.color)
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(mod.config.linewidth)
    mouseCircle:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end

function mod.init()
   hs.hotkey.bind(mod.config.mouse_locate_key[1], mod.config.mouse_locate_key[2], mouseHighlight)
end

return mod
