----------------------------------------------------------------
-- Sceneを管理するマネージャクラスです
-- シーンのライフサイクルの管理やイベント制御を行います。
--
----------------------------------------------------------------
SceneManager = EventDispatcher:new()

---------------------------------------
-- コンストラクタです。
---------------------------------------
function SceneManager:initialize()
    self.scenes = {}
    self.sceneFactory = SceneFactory:new()
    self.currentScene = nil
    self.nextScene = nil
    self.transitioning = false
    self.sceneAnimation = nil
    
    -- イベントリスナーの設定
    InputManager:addListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    InputManager:addListener(Event.TOUCH_UP, self.onTouchUp, self)
    InputManager:addListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    InputManager:addListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
    InputManager:addListener(Event.KEYBOARD, self.onKeyboard, self)
    Application:addListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

---------------------------------------
-- 新しいシーンを表示します。
-- 現在のシーンはそのままスタックされた状態で、
-- 次のシーンを表示します。
--
-- params引数で、いくつかの動作を変更できます。
-- 1. params.sceneClassを指定した場合、
--    Sceneクラスではなく、別のクラスをnewします。
-- 2. params.animationを指定した場合、
--    
---------------------------------------
function SceneManager:openScene(sceneName, params)
    if self.transitioning then
        return nil
    end

    params = params and params or {}
    
    -- シーンの検索
    local currentScene = self.currentScene
    local nextScene = self:findSceneByName(sceneName)
    
    -- 既に現在のシーンを表示していた場合
    if currentScene and currentScene == nextScene then
        return
    end
    
    -- 現在のシーンは一時停止
    if currentScene then
        currentScene:onPause()
        if params.currentClosing then
            currentScene:onStop()
        end
    end
    
    -- 起動中のシーンがない場合中の場合
    if not nextScene then
        local scene = self.sceneFactory:createScene(sceneName, params)
        scene:onCreate()
        self:addScene(scene)
        
        nextScene = scene
    else
        self:orderToFront(scene)
    end
    
    -- シーンの表示完了時の処理
    local completeFunc = function()
        if currentScene and params.currentClosing then
            self:removeScene(currentScene)
            currentScene:onDestroy()
        end
        
        self.transitioning = false
        nextScene:onStart()
        nextScene:onResume()
    end
        
    -- アニメーションを行う
    local animation = params.animation
    if animation then
        self.transitioning = true
        animation.currentScene = currentScene
        animation.nextScene = nextScene
        self.sceneAnimation:play({onComplete = completeFunc})
    else
        completeFunc()
    end
    
    return nextScene
end

---------------------------------------
-- 次のシーンに遷移します。
-- 現在のシーンは終了します。
---------------------------------------
function SceneManager:openNextScene(sceneName, params)
    params = params and params or {}
    params.currentClosing = true
    self:openScene(sceneName, params)
end

---------------------------------------
-- 現在のシーンを終了します。
-- 前のシーンに遷移します。
---------------------------------------
function SceneManager:closeScene(params)
    if self.transitioning then
        return nil
    end
    if #self.scenes == 0 then
        return nil
    end
    
    params = params and params or {}

    -- シーンの検索
    local currentScene = self.currentScene
    local nextScene = self.scenes[#self.scenes - 1]

    -- 既に現在のシーンを表示していた場合
    if currentScene and currentScene == nextScene then
        return
    end
    
    -- stop開始
    currentScene:onStop()
    
    -- stop時の処理
    local completeFunc = function()
        self.transitioning = false
        self:removeScene(currentScene)
        currentScene:onDestroy()
        if nextScene then
            nextScene:onResume()
        end
    end
    
    -- アニメーションを行う場合
    local animation = params.animation
    if animation then
        self.transitioning = true
        animation.currentScene = currentScene
        animation.nextScene = nextScene
        animation:play({onComplete = completeFunc})
    else
        completeFunc()
    end
    
    return nextScene
end

---------------------------------------
-- 
---------------------------------------
function SceneManager:animateScene(currentScene, nextScene, animation)

end

---------------------------------------
-- レンダラーパスの表示順を反映します。
---------------------------------------
function SceneManager:refreshRenders()
    MOAISim.clearRenderStack()
    for i, scene in ipairs(self.scenes) do
        scene:showRenders()
    end
end

---------------------------------------
-- シーンを追加します。
---------------------------------------
function SceneManager:addScene(scene)
    if table.indexOf(self.scenes, scene) == 0 then
        table.insert(self.scenes, scene)
        self.currentScene = scene
        scene:showRenders()
    end
end

---------------------------------------
-- シーンを削除します。
---------------------------------------
function SceneManager:removeScene(scene)
    local i = table.indexOf(self.scenes, scene)
    if i > 0 then
        table.remove(self.scenes, i)

        local maxn = table.maxn(self.scenes)
        if maxn > 0 then
            self.currentScene = self.scenes[maxn]
        else
            self.currentScene = nil
        end
        
        self:refreshRenders()
    end
end

---------------------------------------
-- シーン名からシーンを検索して返します。
-- 見つからない場合はnilを返します。
---------------------------------------
function SceneManager:findSceneByName(sceneName)
    for i, scene in ipairs(self.scenes) do
        if scene.name == sceneName then
            return scene
        end
    end
    return nil
end

---------------------------------------
-- シーンを最前面に移動します。
---------------------------------------
function SceneManager:orderToFront(scene)
    if #self.scenes <= 1 then
        return
    end
    
    local i = table.indexOf(self.scenes, scene)
    if i > 0 then
        table.remove(self.scenes, i)
        table.insert(self.scenes, scene)
        self.currentScene = scene
        self:refreshRenders()
    end
end

---------------------------------------
-- シーンを最背面に移動します。
---------------------------------------
function SceneManager:orderToBack(scene)
    if #self.scenes <= 1 then
        return
    end    
    local i = table.indexOf(self.scenes, scene)
    if i > 0 then
        table.remove(self.scenes, i)
        table.insert(self.scenes, 1, scene)
        self.currentScene = self.scenes[#self.scenes]
        self:refreshRenders()
    end
end

---------------------------------------
-- 画面をタッチする処理を行います。
---------------------------------------
function SceneManager:onTouchDown(e)
    if self.currentScene and self.currentScene:isOpened() then
        self.currentScene:onSceneTouchDown(e)
    end
end

---------------------------------------
-- 画面をタッチする処理を行います。
---------------------------------------
function SceneManager:onTouchUp(e)
    if self.currentScene and self.currentScene:isOpened() then
        self.currentScene:onSceneTouchUp(e)
    end
end

---------------------------------------
-- 画面をタッチする処理を行います。
---------------------------------------
function SceneManager:onTouchMove(e)
    if self.currentScene and self.currentScene:isOpened() then
        self.currentScene:onSceneTouchMove(e)
    end
end

---------------------------------------
-- 画面をタッチする処理を行います。
---------------------------------------
function SceneManager:onTouchCancel(e)
    if self.currentScene and self.currentScene:isOpened() then
        self.currentScene:onSceneTouchCancel(e)
    end
end

---------------------------------------
-- キーボード入力する処理を行います。
---------------------------------------
function SceneManager:onKeyboard(e)
    if self.currentScene and self.currentScene:isOpened() then
        self.currentScene:onKeyboard(e)
    end
end

---------------------------------------
-- 毎フレームの処理を行います。
---------------------------------------
function SceneManager:onEnterFrame(e)
    local currentScene = self.currentScene
    if currentScene and currentScene:isOpened() then
        currentScene:onEnterFrame(e)
    end
end
