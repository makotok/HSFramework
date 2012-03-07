module(..., package.seeall)

local preX, preY = 0, 0

function onCreate()
    local map = TMXMapLoader:new():load("samples/resources/platformmap.tmx")
    map.resourceDirectory = "samples/resources/"
    map:drawMap(scene)
end

function onTouchDown(event)
    preX = event.worldX
    preY = event.worldY
end

function onTouchMove(event)
    local moveX, moveY = event.worldX - preX, event.worldY - preY
    local camera = scene.topLayer.camera
    camera.x = camera.x - moveX
    camera.y = camera.y - moveY
end
