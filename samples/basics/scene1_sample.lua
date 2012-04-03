local display = require("hs/core/display")
local Logger = require("hs/core/Logger")

module(..., package.seeall)

-- injection component
-- scene: this module scene.

function onCreate()
    Logger.info("onCreate()", scene.name)
    
    scene.sceneOpenAnimation = "crossFade"
    scene.sceneCloseAnimation = "crossFade"
    
    local sprite1 = display:newSprite("samples/resources/back_1.png")
    local sprite2 = display:newSprite("samples/resources/cathead.png")
    sprite2.x = 10
    sprite2.y = 10
end

function onStart()
    Logger.info("onStart()", scene.name)
end

function onResume()
    Logger.info("onResume()", scene.name)
end

function onPause()
    Logger.info("onPause()", scene.name)
end

function onStop()
    Logger.info("onStop()", scene.name)
end

function onDestroy()
    Logger.info("onDestroy()", scene.name)
end

function onEnterFrame()
    --Logger.info("onEnterFrame()", scene.name)
end

function onKeyboard(event)
    Logger.info("key = " .. event.key .. ", down = " .. tostring(event.down))
end

function onTouchDown(event)
    display:openScene("samples/basics/scene2_sample")
end

