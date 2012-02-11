-- window
Application:openWindow("title", 480, 320)

-- scene
local scene = Scene:new()

-- sprite1
local sprite1 = Sprite:new("samples/basics/cathead.png")
sprite1.parent = scene
sprite1.x = 10
sprite1.y = 10

-- spritesheet
local sprite2 = SpriteSheet:new("samples/basics/actor.png", 3, 4)
sprite2.parent = scene
sprite2:setLocation(20 + sprite1.width, 10)

-- graphics
local g = Graphics:new(50, 50)
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
sprite1:moveLocation(50, 50, 1, nil,
    function(target)
        Log.debug("move complete!", "")
    end
)

-- debug
Log.debug("sprite1:", sprite1.x, sprite1.y, sprite1.width, sprite1.height)
Log.debug("sprite2:", sprite2.x, sprite2.y, sprite2.width, sprite2.height)
Log.debug("graphics:", g.x, g.y, g.width, g.height)
