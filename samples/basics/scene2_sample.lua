local display = require("hs/core/display")
local Logger = require("hs/core/Logger")

module(..., package.seeall)

-- Injection component.
-- scene: this module scene.

function onCreate()
    Logger.info("onCreate()", scene.name)

    --scene.sceneOpenAnimation = SceneAnimation.popIn
    --scene.sceneCloseAnimation = SceneAnimation.popOut
    
    display:newSprite("samples/resources/back_2.png")
    display:newSprite("samples/resources/cathead.png", {x = 50, y = 50})
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
    display:closeScene()
end

