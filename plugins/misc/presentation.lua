-- Preload the modules we're going to need
require("hs.chooser")
require("hs.webview")
require("hs.drawing")

-- Storage for persistent screen objects
local presentationControl = nil
local presentationScreen = nil
local slideBackground = nil
local slideHeader = nil
local slideBody = nil
local slideFooter = nil
local slideModal = nil

-- Configuration for persistent screen objects
local slideHeaderFont = nil
local slideHeaderSize = nil
local slideBodyFont = nil
local slideBodySize = nil
local slideFooterFont = nil
local slideFooterSize = nil

-- Metadata for slide progression
local startSlide = 1
local currentSlide = 0

-- Storage for transient screen objects
local refs = {}

-- Definitions of the slides
local slides = {
    {
        ["header"] = "Hammerspoon",
        ["body"] = [[Staggeringly powerful desktop automation]],
        ["enterFn"] = function()
            if not refs["titleSlideWebview"] then
                print("Creating webview")
                local frame = presentationScreen:fullFrame()
                local x = frame["x"] + ((frame["w"] - 100)*0.66) + 10
                local y = slideHeader:frame()["y"] + slideHeader:frame()["h"] + 10
                local w = ((frame["w"] - 100)*0.33) - 10
                local h = slideBody:frame()["h"]
                local webViewRect = hs.geometry.rect(x, y, w, h)
                local webview = hs.webview.new(webViewRect)
                webview:setLevel(hs.drawing.windowLevels["screenSaver"] + 1)
                webview:url("http://www.hammerspoon.org/go/")
                refs["titleSlideWebview"] = webview
            end
                local webview = refs["titleSlideWebview"]
                webview:show(0.3)
            print("Entered title slide")
        end,
        ["exitFn"] = function()
            print("Hiding webview")
            local webview = refs["titleSlideWebview"]
            webview:hide(0.2)
            print("Exited title slide")
        end,
    },
    {
        ["header"] = "What is it?",
        ["body"] = [[Hammerspoon exposes many OS X system APIs to a Lua environment, so you can script your environment]]
    },
}

-- Draw a slide on the screen, creating persistent screen objects if necessary
function renderSlide(slideNum)
    print("renderSlide")
    if not slideNum then
        slideNum = currentSlide
    end
    print("  slide number: "..slideNum)

    local slideData = slides[slideNum]
    local frame = presentationScreen:fullFrame()

    if not slideBackground then
        slideBackground = hs.drawing.rectangle(frame)
        slideBackground:setLevel(hs.drawing.windowLevels["screenSaver"])
        slideBackground:setFillColor(hs.drawing.color.hammerspoon["osx_yellow"])
        slideBackground:setFill(true)
        slideBackground:show(0.2)
    end

    if not slideHeader then
        slideHeader = hs.drawing.text(hs.geometry.rect(frame["x"] + 50,
                                                       frame["y"] + 50,
                                                       frame["w"] - 100,
                                                       frame["h"] / 10),
                                                       "")
        slideHeader:setTextColor(hs.drawing.color.x11["black"])
        slideHeader:setTextSize(slideHeaderSize)
        slideHeader:orderAbove(slideBackground)
    end

    slideHeader:setText(slideData["header"])
    slideHeader:show(0.5)

    if not slideBody then
        slideBody = hs.drawing.text(hs.geometry.rect(frame["x"] + 50,
                                                     slideHeader:frame()["y"] + slideHeader:frame()["h"] + 10,
                                                     (frame["w"] - 100)*0.66,
                                                     (frame["h"] / 10) * 8),
                                                     "")
        slideBody:setTextColor(hs.drawing.color.x11["black"])
        slideBody:setTextSize(slideBodySize)
        slideBody:orderAbove(slideBackground)
    end

    slideBody:setText(slideData["body"])
    slideBody:show(0.5)

    if not slideFooter then
        slideFooter = hs.drawing.text(hs.geometry.rect(frame["x"] + 50,
                                                       frame["y"] + frame["h"] - 50 - slideFooterSize,
                                                       frame["w"] - 100,
                                                       frame["h"] / 25),
                                                       "Hammerspoon: Staggeringly powerful desktop automation")
        slideFooter:setTextColor(hs.drawing.color.x11["black"])
        slideFooter:setTextSize(slideFooterSize)
        slideFooter:orderAbove(slideBackground)
        slideFooter:show(0.5)
    end
end

-- Move one slide forward
function nextSlide()
    if currentSlide < #slides then
        if slides[currentSlide] and slides[currentSlide]["exitFn"] then
            print("running exitFn for slide")
            slides[currentSlide]["exitFn"]()
        end

        currentSlide = currentSlide + 1
        renderSlide()

        if slides[currentSlide] and slides[currentSlide]["enterFn"] then
            print("running enterFn for slide")
            slides[currentSlide]["enterFn"]()
        end
    end
end

-- Move one slide back
function previousSlide()
    if currentSlide > 1 then
        if slides[currentSlide] and slides[currentSlide]["exitFn"] then
            print("running exitFn for slide")
            slides[currentSlide]["exitFn"]()
        end

        currentSlide = currentSlide - 1
        renderSlide()

        if slides[currentSlide] and slides[currentSlide]["enterFn"] then
            print("running enterFn for slide")
            slides[currentSlide]["enterFn"]()
        end
    end
end

-- Exit the presentation
function endPresentation()
    hs.caffeinate.set("displayIdle", false, true)
    if slides[currentSlide] and slides[currentSlide]["exitFn"] then
        print("running exitFn for slide")
        slides[currentSlide]["exitFn"]()
    end
    slideHeader:hide(0.5)
    slideBody:hide(0.5)
    slideFooter:hide(0.5)
    slideBackground:hide(1)

    hs.timer.doAfter(1, function()
        slideHeader:delete()
        slideBody:delete()
        slideFooter:delete()
        slideBackground:delete()
        slideModal:exit()
    end)
end

-- Prepare the modal hotkeys for the presentation
function setupModal()
    print("setupModal")
    slideModal = hs.hotkey.modal.new({}, nil, nil)

    slideModal:bind({}, "left", previousSlide)
    slideModal:bind({}, "right", nextSlide)
    slideModal:bind({}, "escape", endPresentation)

    slideModal:enter()
end

-- Callback for when we've chosen a screen to present on
function didChooseScreen(choice)
    if not choice then
        print("Chooser cancelled")
        return
    end
    print("didChooseScreen: "..choice["text"])
    presentationScreen = hs.screen.find(choice["uuid"])
    if not presentationScreen then
        hs.notify.show("Unable to find that screen, using primary screen")
        presentationScreen = hs.screen.primaryScreen()
    else
        print("Found screen")
    end

    setupModal()

    local frame = presentationScreen:fullFrame()
    slideHeaderSize = frame["h"] / 15
    slideBodySize   = frame["h"] / 22
    slideFooterSize = frame["h"] / 30

    nextSlide()
end

-- Prepare a table of screens for hs.chooser
function screensToChoices()
    print("screensToChoices")
    local choices = hs.fnutils.map(hs.screen.allScreens(), function(screen)
        local name = screen:name()
        local id = screen:id()
        local image = screen:snapshot()
        local mode = screen:currentMode()["desc"]

        return {
            ["text"] = name,
            ["subText"] = mode,
            ["uuid"] = id,
            ["image"] = image,
        }
    end)

    return choices
end

-- Initiate the hs.chosoer for choosing a screen to present on
function chooseScreen()
    print("chooseScreen")
    local chooser = hs.chooser.new(didChooseScreen)
    chooser:choices(screensToChoices)
    chooser:show()
end

-- Prepare the presentation
function setupPresentation()
    print("setupPresentation")
    hs.caffeinate.set("displayIdle", true, true)
    chooseScreen()
end

-- Create a menubar object to initiate the presentation
presentationControl = hs.menubar.new()
--presentationControl:setIcon(hs.image.imageFromName(hs.image.systemImageNames["EnterFullScreenTemplate"]))
presentationControl:setIcon(hs.image.imageFromName("NSComputer"))
presentationControl:setMenu({{ title = "Start Presentation", fn = setupPresentation }})

