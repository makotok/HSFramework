-- scene
textlabel_sample = Scene:new()
local scene = textlabel_sample

function scene:onOpen(event)
    -- group
    local group = Group:new({layout = VBoxLayout:new(), parent = scene})
    
    -- label
    local label1 = TextLabel:new({text = "hello world!", width = 480, height = 25, parent = group})
    local label2 = TextLabel:new({text = "1234567890", width = 480, height = 25, parent = group})
    local label3 = TextLabel:new({text = "こんにちわ!", width = 480, height = 40, fontSize = 16, parent = group})
    
    -- test animation
    Animation:new(group, 1):move(0, 50):rotate(360):scale(1, 1):scale(-1, -1):play()
end

-- close event
function scene:onClose(event)
end

