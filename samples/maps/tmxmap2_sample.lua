local display = require "hs/core/display"
local widget = require "hs/gui/widget"
local TMXMapLoader = require "hs/tmx/TMXMapLoader"

module(..., package.seeall)

function onCreate()
    local scrollView = widget:newScrollView()
    local map = TMXMapLoader:new():load("samples/resources/platformmap.tmx")
    map.resourceDirectory = "samples/resources/"
    map:drawMap(scrollView)
end
