module(..., package.seeall)

local preX, preY = 0, 0

function onCreate()
    local map = TMXMapLoader:new():load("samples/resources/platformmap.tmx")
    map.resourceDirectory = "samples/resources/"
    map:drawMap(scene)
end

function onTouchDown(event)
    preX = event.x
    preY = event.y
end

function onTouchMove(event)
    local screenX, screenY = event.x, event.y
    local moveX, moveY = preX - screenX, preY - screenY

    local camera = scene.topLayer.camera
    camera.x = camera.x + moveX
    camera.y = camera.y + moveY
    
    preX, preY = screenX, screenY
end
