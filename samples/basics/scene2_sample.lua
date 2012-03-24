module(..., package.seeall)

-- Injection component.
-- scene: this module scene.

function onCreate()
    Logger.info("onCreate()", scene.name)

    scene.sceneOpenAnimation = SceneAnimation.popIn
    scene.sceneCloseAnimation = SceneAnimation.popOut
    
    Sprite:new("samples/resources/back_2.png", {parent = scene})
    Sprite:new("samples/resources/cathead.png", {x = 50, y = 50, parent = scene})
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
    SceneManager:closeScene()
end

