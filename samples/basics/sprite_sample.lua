-- window
Application:openWindow("title", 480, 320)

-- scene
local scene = Scene:new()

-- sprite1
local sprite1 = Sprite:new("samples/images/cathead.png")
sprite1.parent = scene
sprite1.x = 10
sprite1.y = 10

-- spritesheet
local sprite2 = SpriteSheet:new("samples/images/actor.png", 3, 4)
sprite2.parent = scene
sprite2:setLocation(20 + sprite1.width, 10)

-- graphics
local g = Graphics:new({width = 50, height = 50})
g.x = 10
g.y = 20 + sprite1.height
g.parent = scene

g:setPenColor(0, 1, 0, 1)
g:fillRect(0, 0, 50, 50)
g:setPenColor(1, 0, 0, 1)
g:setPenWidth(1)
g:drawRect(0, 0, 50, 50)

scene:openScene()

-- move
sprite1:move(50, 50, 1, nil,
    function(target)
        target:fadeOut(1, nil, function(target) target:fadeIn(1) end)
    end
)

