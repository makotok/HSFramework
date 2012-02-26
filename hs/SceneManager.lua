SceneManager = Class()

---------------------------------------
-- コンストラクタです。
---------------------------------------
function SceneManager:init()
    Class.init(self)
    self.scenes = {}
    self.currentScene = nil
    
    -- イベントリスナーの設定
    InputManager:addListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    InputManager:addListener(Event.TOUCH_UP, self.onTouchUp, self)
    InputManager:addListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    InputManager:addListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
    InputManager:addListener(Event.KEYBORD, self.onKeybord, self)
    Application:addListener(Event.ENTER_FRAME, self.onEnterFrame, self)
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
function SceneManager:onKeybord(e)
    if self.currentScene and self.currentScene:isOpened() then
        self.currentScene:onKeybord(e)
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
