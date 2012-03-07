module(..., package.seeall)

function onCreate()
    -- group
    group = Group:new({layout = VBoxLayout:new(), parent = scene})
    
    -- label
    label1 = TextLabel:new({text = "hello world!", width = 480, height = 25, parent = group})
    label2 = TextLabel:new({text = "1234567890", width = 480, height = 25, parent = group})
    label3 = TextLabel:new({text = "こんにちわ!", width = 480, height = 40, fontSize = 16, parent = group})
    
end

function onStart()
    animation = Animation:new(group, 1):move(0, 50):rotate(360):scale(1, 1):scale(-1, -1):play()
end

function onPause()
    if animation then
        animation:stop()
    end
end
