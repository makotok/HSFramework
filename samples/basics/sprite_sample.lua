module(..., package.seeall)

function onCreate()
    -- group
    group = Group:new({parent = scene, layout = VBoxLayout:new()})
    
    -- sprite
    sprite1 = Sprite:new("samples/resources/cathead.png", {width = 64, height = 64, parent = group})
    sprite2 = Sprite:new("samples/resources/cathead.png", {width = 64, height = 64, parent = group, flipX = true})
    sprite3 = Sprite:new("samples/resources/cathead.png", {width = 64, height = 64, parent = group, flipY = true})
    sprite4 = Sprite:new("samples/resources/cathead.png", {width = 64, height = 64, parent = group, flipX = true, flipY = true})
    
end
