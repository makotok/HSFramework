SceneManager = Class()

---------------------------------------
-- コンストラクタです。
---------------------------------------
function SceneManager:init()
    Class.init(self)
    self.scenes = {}
    self.currentScene = nil
    
    -- イベントリスナーの設定
    InputManager:addListener(Event.TOUCH, self.onTouch, self)
    InputManager:addListener(Event.KEYBORD, self.onTouch, self)
end

---------------------------------------
-- レンダラーパスの表示順を反映します。
---------------------------------------
function SceneManager:refreshRenders()
    MIAISim.clearRenderStack()
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
function SceneManager:onTouch(e)
    if self.currentScene and self.currentScene:isOpened() then
        currentScene:onTouch(e)
    end
end

---------------------------------------
-- キーボード入力する処理を行います。
---------------------------------------
function SceneManager:onKeybord(e)
    if self.currentScene and self.currentScene:isOpened() then
        currentScene:onKeybord(e)
    end
end
