module(..., package.seeall)

-- injection component
-- scene: this module scene.

function onCreate()
    Log.info("onCreate()", scene.name)
    
    Sprite:new("samples/resources/back_1.png", {parent = scene})
    Sprite:new("samples/resources/cathead.png", {x = 10, y = 10, parent = scene})
end

function onStart()
    Log.info("onStart()", scene.name)
end

function onResume()
    Log.info("onResume()", scene.name)
end

function onPause()
    Log.info("onPause()", scene.name)
end

function onStop()
    Log.info("onStop()", scene.name)
end

function onDestroy()
    Log.info("onDestroy()", scene.name)
end

function onEnterFrame()
    --Log.info("onEnterFrame()", scene.name)
end

function onKeyboard(event)
    Log.info("key = " .. event.key .. ", down = " .. tostring(event.down))
end

function onTouchDown(event)
    SceneManager:openNextScene("samples/basics/scene2_sample")
end

