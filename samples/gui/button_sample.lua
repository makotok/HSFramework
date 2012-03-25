local display = require "hs/core/display"
local widget = require "hs/gui/widget"

module(..., package.seeall)

function onCreate()
    -- group
    group = display:newGroup({layout = display:newBoxLayout()})
    
    -- button
    button1 = widget:newButton({text = "hello!", textAlign = "center", width = 200, height = 30, parent = group})
end

function onStart()
end
