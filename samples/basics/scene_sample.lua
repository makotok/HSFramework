-- window
Application:openWindow("title", 480, 320)

-- scenes
local scene1 = Scene:new()
Sprite:new("samples/images/back_1.png", {parent = scene1})
Sprite:new("samples/images/cathead.png", {x = 10, y = 10, parent = scene1})

local scene2 = Scene:new()
Sprite:new("samples/images/back_2.png", {parent = scene2})
Sprite:new("samples/images/cathead.png", {x = 50, y = 50, parent = scene2})

-- animations
local openAnim1 = Animation:new(scene1, 1):copy({x = -25, y = 0}):parallel(
    Animation:new(scene1, 1):move(25, 0),
    Animation:new(scene1, 1):fadeIn())

local closeAnim1 = Animation:new(scene1, 1):parallel(
    Animation:new(scene1, 1):move(25, 0),
    Animation:new(scene1, 1):fadeOut())

local openAnim2 = Animation:new(scene2, 1):copy({x = -25, y = 0}):parallel(
    Animation:new(scene2, 1):move(25, 0),
    Animation:new(scene2, 1):fadeIn())
    
local closeAnim2 = Animation:new(scene2, 1):parallel(
    Animation:new(scene2, 1):move(25, 0),
    Animation:new(scene2, 1):fadeOut())

-- scene1 functions
function scene1:onTouch(e)
    if e.touchType == Event.DOWN then
        scene1:closeScene({animation = closeAnim1, onComplete =
            function()
                scene2:openScene({animation = openAnim2})
            end}
        )
    end
end

-- scene2 functions
function scene2:onTouch(e)
    if e.touchType == Event.DOWN then
        scene2:closeScene({animation = closeAnim2, onComplete =
            function()
                scene1:openScene({animation = openAnim1})
            end}
        )
    end
end

scene1:openScene({animation = openAnim1})

