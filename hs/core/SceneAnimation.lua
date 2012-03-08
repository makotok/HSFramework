--------------------------------------------------------------------------------
-- Sceneクラスをアニメーションする為の関数群です。
-- 実態はクラスではなく、Animationクラスを返す関数の集まりです。
--------------------------------------------------------------------------------
SceneAnimation = {}
SceneAnimation.defaultSecond = 0.5

---------------------------------------
-- 即座に表示します。
---------------------------------------
function SceneAnimation.now(currentScene, nextScene, params)
    return Animation:new():parallel(
        Animation:new(currentScene, sec):copy({visible = false}),
        Animation:new(nextScene, sec):copy({x = 0, y = 0, visible = true})
    )
end

---------------------------------------
-- ポップアップ表示します。
---------------------------------------
function SceneAnimation.popIn(currentScene, nextScene, params)
    local sec = params.sec and params.sec or SceneAnimation.defaultSecond
    return Animation:new():parallel(
        Animation:new(currentScene, sec):color(-0.5, -0.5, -0.5, -0.5),
        Animation:new(nextScene, sec):copy({x = 0, y = 0, scaleX = 0, scaleY = 0, visible = true})
            :scale(1, 1):copy({scaleX = 1, scaleY = 1})
    )
end

---------------------------------------
-- ポップアップ表示をクローズします。
-- ポップアップ表示したシーンに対してのみ有効です。
---------------------------------------
function SceneAnimation.popOut(currentScene, nextScene, params)
    local sec = params.sec and params.sec or SceneAnimation.defaultSecond
    return Animation:new():parallel(
        Animation:new(currentScene, sec):scale(-1, -1):copy({visible = false}),
        Animation:new(nextScene, sec):color(0.5, 0.5, 0.5, 0.5):copy({red = 1, green = 1, blue = 1, alpha = 1})
    )
end

---------------------------------------
-- fadeOut,fadeInを順次行います。
---------------------------------------
function SceneAnimation.fade(currentScene, nextScene, params)
    local sec = params.sec and params.sec or SceneAnimation.defaultSecond
    return Animation:new():sequence(
        Animation:new(currentScene, sec):fadeOut(),
        Animation:new(nextScene, sec):fadeIn()
    )
end

---------------------------------------
-- fadeOut,fadeInを並列して行います。
---------------------------------------
function SceneAnimation.crossFade(currentScene, nextScene, params)
    local sec = params.sec and params.sec or SceneAnimation.defaultSecond
    return Animation:new():parallel(
        Animation:new(currentScene, sec):fadeOut(),
        Animation:new(nextScene, sec):fadeIn()
    )
end

---------------------------------------
-- 画面上の移動します。
---------------------------------------
function SceneAnimation.slideToTop(currentScene, nextScene, params)
    local sec = params.sec and params.sec or SceneAnimation.defaultSecond
    local sw, sh = Application.screenWidth, Application.screenHeight
    return Animation:new():parallel(
        Animation:new(currentScene, sec):copy({x = 0, y = 0}):move(0, -sh):copy({visible = false}),
        Animation:new(nextScene, sec):copy({x = 0, y = sh, visible = true}):move(0, -sh):copy({y = 0})
    )
end

---------------------------------------
-- 画面下の移動します。
---------------------------------------
function SceneAnimation.slideToBottom(currentScene, nextScene, params)
    local sec = params.sec and params.sec or SceneAnimation.defaultSecond
    local sw, sh = Application.screenWidth, Application.screenHeight
    return Animation:new():parallel(
        Animation:new(currentScene, sec):copy({x = 0, y = 0}):move(0, sh):copy({visible = false}),
        Animation:new(nextScene, sec):copy({x = 0, y = -sh, visible = true}):move(0, sh):copy({y = 0})
    )
end

---------------------------------------
-- 画面左の移動します。
---------------------------------------
function SceneAnimation.slideToLeft(currentScene, nextScene, params)
    local sec = params.sec and params.sec or SceneAnimation.defaultSecond
    local sw, sh = Application.screenWidth, Application.screenHeight
    return Animation:new():parallel(
        Animation:new(currentScene, sec):copy({x = 0, y = 0}):move(-sw, 0):copy({visible = false}),
        Animation:new(nextScene, sec):copy({x = sw, y = 0, visible = true}):move(-sw, 0):copy({x = 0})
    )
end

---------------------------------------
-- 画面右の移動します。
---------------------------------------
function SceneAnimation.slideToRight(currentScene, nextScene, params)
    local sec = params.sec and params.sec or SceneAnimation.defaultSecond
    local sw, sh = Application.screenWidth, Application.screenHeight
    return Animation:new():parallel(
        Animation:new(currentScene, sec):copy({x = 0, y = 0}):move(sw, 0):copy({visible = false}),
        Animation:new(nextScene, sec):copy({x = -sw, y = 0, visible = true}):move(sw, 0):copy({x = 0})
    )
end

