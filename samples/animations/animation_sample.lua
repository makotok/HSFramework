-- window
Application:openWindow("title", 480, 320)

-- scene
local scene = Scene:new()

-- sprite1
local sprite1 = Sprite:new("samples/images/cathead.png", {parent = scene})

-- touch event
function scene:onTouch(e)
    if e.touchType == Event.DOWN then
        animate()
    end
end

-- complete handler
function onCompleteAnimation(e)
    Log.info("animation complete!")
end

-- animate
local animation = Animation:new(sprite1)
    :setLocation(0, 0):setRotation(0):setScale(1, 1)
    :move(sprite1.width / 2, sprite1.height / 2, 1):wait(3)
    :parallel(
        Animation:new(sprite1):rotate(90, 1),
        Animation:new(sprite1):scale(1, 1, 1)
    )
    
function animate()
    if animation.running then
        animation:stop()
    else
        animation:play({onComplete = onCompleteAnimation})
    end
end
animate()

scene:openScene()

