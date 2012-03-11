module(..., package.seeall)

function onCreate()
    world = Box2DWorld:new({layer = scene.topLayer, debugDraw = true})
    
    -- body1
    -- property access support
    body1 = world:addBody(MOAIBox2DBody.DYNAMIC, {x = 10, y = 10, angle = 45})
    body1.y = 0
    fixture1 = body1:addRect(0, 0, 20, 20)
    body1:resetMassData()
    body1:applyAngularImpulse(2)

    body2 = world:addBody(MOAIBox2DBody.DYNAMIC, {x = 40, y = 10})
    body2:addCircle(0, 0, 10)
    body2:resetMassData()
    body2:applyAngularImpulse(2)
    
    floor = world:addBody(MOAIBox2DBody.STATIC)
    floor:addRect(0, scene.height - 20, scene.width, scene.height - 10)
    
end

function onStart()
    world:start()
end
