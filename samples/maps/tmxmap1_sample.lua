local display = require "hs/core/display"
local widget = require "hs/gui/widget"
local TMXMapLoader = require "hs/tmx/TMXMapLoader"

module(..., package.seeall)

function onCreate()
    local scrollView = widget:newScrollView()
    local map = TMXMapLoader:new():load("samples/resources/demomap.tmx")
    --local map = TMXMapLoader:new():load("samples/resources/demomap2.tmx") -- hide visible test
    map.resourceDirectory = "samples/resources/"
    map:drawMap(scrollView)
end
