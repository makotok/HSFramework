----------------------------------------------------------------
-- Sceneはシーングラフを構築するトップレベルコンテナです。
-- Sceneは複数のレイヤーを管理します。
-- このクラスを使用して、画面を構築します。
----------------------------------------------------------------
Scene = EventDispatcher()

-- getters
Scene:setPropertyName("layers")
Scene:setPropertyName("topLayer")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Scene:init()
    Scene:super(self)

    -- 変数
    self.name = ""
    self._layers = {}
    self._screenX = 0
    self._screenY = 0
    self._opened = false
    self._topLayer = Layer:new()
    self:addLayer(self.topLayer)

end

---------------------------------------
-- シーンを開きます
---------------------------------------
function Scene:openScene(effect)
    -- 開いた時の処理
    local event = Event.new(Event.OPEN, self)
    self:onOpen(event)
    self:dispatchEvent(event)

    -- ログ
    Log.debug(self.name .. ":onOpen(event)")

    -- マネージャにスタック
    Application:addScene(self)
    self._opened = true
end

---------------------------------------
-- シーンを閉じます
---------------------------------------
function Scene:closeScene(effect)
    -- 閉じた時の処理
    local event = Event.new(Event.CLOSE, self)
    self:onClose(event)
    self:dispatchEvent(event)

    -- ログ
    Log.debug(self.name .. ":onClose(event)")

    -- マネージャから削除
    Application:removeScene(self)
    self._opened = false
end

---------------------------------------
-- シーンを最前面に表示します。
---------------------------------------
function Scene:orderToFront()
    SceneManager:orderToFront(self)
end

---------------------------------------
-- シーンを最背面に表示します。
---------------------------------------
function Scene:orderToBack()
    SceneManager:orderToBack(self)
end

---------------------------------------
-- 描画レイヤーを表示します。
---------------------------------------
function Scene:showRenders()
    for i, layer in ipairs(self.layers) do
        Log.debug("push render!")
        MOAISim.pushRenderPass(layer.renderPass)
    end
end

---------------------------------------
-- カレントシーンかどうか返します。
---------------------------------------
function Scene:isCurrentScene()
    return Application.currentScene == self
end

---------------------------------------
-- 最初に描画するレイヤーを返します。
-- つまり、実際の表示は後ろです。
-- デフォルトで一つだけ追加されているので、
-- 必ず使用できます。
---------------------------------------
function Scene:getTopLayer()
    return self._topLayer
end

---------------------------------------
-- レイヤーを追加します。
---------------------------------------
function Scene:addLayer(layer)
    if table.indexOf(self.layers, layer) > 0 then
        return
    end

    table.insert(self.layers, layer)
    layer.parent = self
    
    if self:isOpened() then
        if self:isCurrentScene() then
            MOAISim.pushRenderPass(layer.renderPass)
        else
            Application.sceneManager:refreshRenders()
        end
    end
end

---------------------------------------
-- レイヤーを削除します。
---------------------------------------
function Scene:removeLayer(layer)
    if self.topLayer == layer then
        return
    end
    if table.indexOf(self.layers, layer) > 0 then
        return
    end

    table.insert(self.layers, layer)
    layer.parent = self
    
    Application.sceneManager:refreshRenders()
end

---------------------------------------
-- レイヤーリストを返します。
---------------------------------------
function Scene:getLayers()
    return self._layers
end

---------------------------------------
-- シーンを開いているか返します。
---------------------------------------
function Scene:isOpened()
    return self._opened
end

---------------------------------------
-- シーンを開いた時のイベントハンドラ関数です
-- 子クラスで継承してください
---------------------------------------
function Scene:onOpen(event)
end

---------------------------------------
-- シーンを閉じた時のイベントハンドラ関数です
-- 子クラスで継承してください
---------------------------------------
function Scene:onClose(event)
end

---------------------------------------
-- 画面をタッチした時のイベント処理です。
-- イベントハンドラ関数です
-- 子クラスで継承してください
---------------------------------------
function Scene:onTouch(event)
end
