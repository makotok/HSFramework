-- scene
anime_basic_sample = Scene:new()
local scene = anime_basic_sample

-- open event
function scene:onOpen()
    local sprite1 = Sprite:new("samples/images/cathead.png", {parent = scene})

    self.animation = Animation:new(sprite1, 1)
        :copy({x = 0, y = 0, rotation = 0, scaleX = 1, scaleY = 1})
        :move(sprite1.width / 2, sprite1.height / 2)
        :wait(3)
        :parallel(
            Animation:new(sprite1, 1):rotate(90),
            Animation:new(sprite1, 1):scale(1, 1)
        )
    
    self:animate()
end

-- close event
function scene:onClose(event)
end

-- touch event
function scene:onTouch(e)
    if e.touchType == Event.DOWN then
        self:animate()
    end
end

function scene:animate()
    if self.animation.running then
        self.animation:stop()
    else
        self.animation:play({onComplete = function(e) Log.info("animation complete!") end})
    end
end
