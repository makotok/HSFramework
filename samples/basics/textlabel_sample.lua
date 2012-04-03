local display = require("hs/core/display")

module(..., package.seeall)

function onCreate()
    -- group
    group = display:newGroup({layout = display:newVBoxLayout()})
    
    -- label
    label1 = display:newText({text = "hello world!", width = 480, height = 25, parent = group})
    label2 = display:newText({text = "1234567890", width = 480, height = 25, parent = group})
    label3 = display:newText({text = "こんにちわ!", width = 480, height = 40, fontSize = 16, parent = group})
    
end

function onStart()
    animation = display:newAnimation(group, 1):moveLocation(0, 50):moveRotation(0, 0, 360):moveScale(1, 1):moveScale(-1, -1):play()
end

function onPause()
    if animation then
        animation:stop()
    end
end
