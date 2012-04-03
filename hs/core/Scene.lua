local table = require("hs/lang/table")
local DisplayObject = require("hs/core/DisplayObject")
local Transform = require("hs/core/Transform")
local Layer = require("hs/core/Layer")
local FunctionUtil = require("hs/util/FunctionUtil")

----------------------------------------------------------------
-- Sceneはシーングラフを構築するトップレベルコンテナです.<br>
-- Sceneは複数のLayerを管理します.<br>
-- このクラスを使用して、画面を構築します.<br>
-- <br>
-- デフォルトのレイヤー（topLayer）を持ちます.<br>
-- DisplayObjectの親に直接指定された場合、実際に追加される先はtopLayerになります.<br>
-- <br>
-- Sceneのライフサイクルについて<br>
-- 1. onCreate()  ... 生成時に呼ばれます.<br>
-- 2. onStart()   ... 開始時に呼ばれます.<br>
-- 3. onResume()   ... 再開時に呼ばれます.<br>
-- 4. onPause()   ... 一時停止時に呼ばれます.<br>
-- 5. onStop()     ... 終了時に呼ばれます.<br>
-- 6. onDestroy() ... 破棄時に呼ばれます.<br>
-- @class table
-- @name Scene
----------------------------------------------------------------
local Scene = Transform()

-- getters
Scene:setPropertyName("width")
Scene:setPropertyName("height")
Scene:setPropertyName("alpha")
Scene:setPropertyName("red")
Scene:setPropertyName("green")
Scene:setPropertyName("blue")
Scene:setPropertyName("layers")
Scene:setPropertyName("topLayer")
Scene:setPropertyName("opened", "setOpened", "isOpened")
Scene:setPropertyName("visible", "setVisible", "isVisible")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Scene:init()
    Scene:super(self)
    
    self.application = require("hs/core/Application")
    self.sceneManager = require("hs/core/SceneManager")

    -- 初期値
    self.name = ""
    self._layers = {}
    self._opened = false
    self._visible = true
    self._topLayer = Layer:new()
    self.sceneHandler = {}
    self.sceneOpenAnimation = "crossFade"
    self.sceneCloseAnimation = "crossFade"
    self:addChild(self.topLayer)
    
    self:setSize(self.application.stageWidth, self.application.stageHeight)
end

---------------------------------------
-- シーンを最前面に表示します.
---------------------------------------
function Scene:orderToFront()
    self.sceneManager:orderToFront(self)
end

---------------------------------------
-- シーンを最背面に表示します.
---------------------------------------
function Scene:orderToBack()
    self.sceneManager:orderToBack(self)
end

---------------------------------------
-- 描画レイヤーを表示します.
---------------------------------------
function Scene:showRenders()
    if not self.visible then
        return
    end
    
    for i, layer in ipairs(self.layers) do
        MOAISim.pushRenderPass(layer.renderPass)
    end
end

---------------------------------------
-- カレントシーンかどうか返します.
---------------------------------------
function Scene:isCurrentScene()
    return self.sceneManager.currentScene == self
end

---------------------------------------
-- 最初に描画するレイヤーを返します.
-- つまり、実際の表示は後ろです.
-- デフォルトで一つだけ追加されているので、
-- 必ず使用できます.
---------------------------------------
function Scene:getTopLayer()
    return self._topLayer
end

---------------------------------------
-- 子レイヤーを追加します.
-- レイヤー以外を指定した場合、topLayerに追加されます.
-- レイヤーの場合はシーンに追加されます.
---------------------------------------
function Scene:addChild(child)
    -- レイヤーでない場合、topLayerに追加
    if not child:instanceOf(Layer) then
        self.topLayer:addChild(child)
        return
    end
    
    if table.indexOf(self.layers, child) > 0 then
        return
    end

    table.insert(self.layers, child)
    child.parent = self
    self:setAttrLinkForChild(child)
    
    if self:isOpened() then
        self.sceneManager:refreshRenders()
    end
end

---------------------------------------
-- レイヤーを削除します.
---------------------------------------
function Scene:removeChild(child)
    -- レイヤーでない場合、topLayerから削除
    if not child:instanceOf(Layer) then
        self.topLayer:removeChild(child)
        return
    end
    if self.topLayer == layer then
        return
    end
    local i = table.indexOf(self.layers, child)
    if i == 0 then
        return
    end

    table.remove(self.layers, i)
    child.parent = nil
    self:setAttrLinkForChild(child)
    
    if self:isOpened() then
        self.sceneManager:refreshRenders()
    end
end

---------------------------------------
-- 子オブジェクトの属性連携を設定します.
---------------------------------------
function Scene:setAttrLinkForChild(child)
    child.prop:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)
    if child.parent then
        child.prop:setAttrLink(MOAITransform.INHERIT_TRANSFORM, child.parent.transformObj, MOAITransform.TRANSFORM_TRAIT)
    end
end

---------------------------------------
-- レイヤーリストを返します.
---------------------------------------
function Scene:getLayers()
    return self._layers
end

---------------------------------------
-- 親オブジェクトを設定します.
-- トップレベルコンテナなので、親はありません.
---------------------------------------
function Scene:setParent(parent)
end

---------------------------------------
-- リソースを削除します.
---------------------------------------
function Scene:dispose()
    for i, layer in ipairs(self.layers) do
        layer:dispose()
    end
end

---------------------------------------
-- サイズを設定します.
-- 基本的にはstageのサイズのみを設定すべきであり、
-- フレームワーク外部から設定すべきではありません.
---------------------------------------
function Scene:setSize(width, height)
    self._width = width
    self._height = height
    self:centerPivot()
end

---------------------------------------
-- サイズを返します.
---------------------------------------
function Scene:getSize()
    return self._width, self._height
end

---------------------------------------
-- widthを設定します.
---------------------------------------
function Scene:setWidth(width)
    self:setSize(width, self._height)
end

---------------------------------------
-- widthを返します.
---------------------------------------
function Scene:getWidth()
    return self._width
end

---------------------------------------
-- heightを設定します.
---------------------------------------
function Scene:setHeight(height)
    self:setSize(self._width, height)
end

---------------------------------------
-- heightを返します.
---------------------------------------
function Scene:getHeight()
    return self._height
end

---------------------------------------
-- 中心点を中央に設定します.
---------------------------------------
function Scene:centerPivot()
    local w, h = self:getSize()
    local px = w / 2
    local py = h / 2
    self:setPivot(px, py)
end

---------------------------------------
-- SceneにLayerはセットできません.
---------------------------------------
function Scene:setLayer(layer)
end

---------------------------------------
-- 子オブジェクトのレイアウトを更新します.
---------------------------------------
function Scene:updateLayout()
    for i, layer in ipairs(self.layers) do
        layer:updateLayout()
    end
end

---------------------------------------
-- 色をアニメーション遷移させます.
---------------------------------------
function Scene:moveColor(red, green, blue, alpha, sec, mode, completeHandler)
    local actionGroup = MOAIAction.new()
    for i, layer in ipairs(self.layers) do
        local action = layer:moveColor(red, green, blue, alpha, sec, mode)
        actionGroup:addChild(action)
    end
    if completeHandler ~= nil then
        actionGroup:setListener(MOAIAction.EVENT_STOP,
            function(prop)
                completeHandler(self)
            end
        )
    end
    actionGroup:start()
    return actionGroup
end

---------------------------------------
-- フェードインします.
---------------------------------------
function Scene:fadeIn(sec, mode, completeHandler)
    local actionGroup = MOAIAction.new()
    for i, layer in ipairs(self.layers) do
        local action = layer:fadeIn(sec, mode)
        actionGroup:addChild(action)
    end
    if completeHandler ~= nil then
        actionGroup:setListener(MOAIAction.EVENT_STOP,
            function(prop)
                completeHandler(self)
            end
        )
    end
    actionGroup:start()
    return actionGroup
end

---------------------------------------
-- フェードアウトします.
---------------------------------------
function Scene:fadeOut(sec, mode, completeHandler)
    local actionGroup = MOAIAction.new()
    for i, layer in ipairs(self.layers) do
        local action = layer:fadeOut(sec, mode)
        actionGroup:addChild(action)
    end
    if completeHandler ~= nil then
        actionGroup:setListener(MOAIAction.EVENT_STOP,
            function(prop)
                completeHandler(self)
            end
        )
    end
    actionGroup:start()
    return actionGroup
end

---------------------------------------
-- 色を設定します.
---------------------------------------
function Scene:setColor(red, green, blue, alpha)
    for i, layer in ipairs(self.layers) do
        layer:setColor(red, green, blue, alpha)
    end
end

---------------------------------------
-- alpha値を設定します.
---------------------------------------
function Scene:setAlpha(alpha)
    self:setColor(self.red, self.green, self.blue, alpha)
end

---------------------------------------
-- alpha値を返します.
---------------------------------------
function Scene:getAlpha()
    return self.topLayer.alpha
end

---------------------------------------
-- red値を設定します.
---------------------------------------
function Scene:setRed(red)
    self:setColor(red, self.green, self.blue, self.alpha)
end

---------------------------------------
-- red値を返します.
---------------------------------------
function Scene:getRed()
    return self.topLayer.red
end

---------------------------------------
-- green値を設定します.
---------------------------------------
function Scene:setGreen(green)
    self:setColor(self.red, green, self.blue, self.alpha)
end

---------------------------------------
-- green値を返します.
---------------------------------------
function Scene:getGreen()
    return self.topLayer.green
end

---------------------------------------
-- blue値を設定します.
---------------------------------------
function Scene:setBlue(blue)
    self:setColor(self.red, self.green, blue, self.alpha)
end

---------------------------------------
-- blue値を返します.
---------------------------------------
function Scene:getBlue()
    return self.topLayer.blue
end

---------------------------------------
-- 表示するか設定します.
---------------------------------------
function Scene:setVisible(visible)
    self._visible = visible
    if self:isOpened() then
        self.sceneManager:refreshRenders()
    end
end

---------------------------------------
-- 表示するか返します.
---------------------------------------
function Scene:isVisible(visible)
    return self._visible
end

---------------------------------------
-- 起動したかどうか返します.
---------------------------------------
function Scene:isOpened()
    return self._opened
end

---------------------------------------
-- シーンの生成処理時に一度だけ呼ばれます.
---------------------------------------
function Scene:onCreate(params)
    FunctionUtil.callExist(self.sceneHandler.onCreate, params)
    self._opened = true
end

---------------------------------------
-- シーンの開始時に一度だけ呼ばれます.
---------------------------------------
function Scene:onStart(params)
    FunctionUtil.callExist(self.sceneHandler.onStart, params)
end

---------------------------------------
-- シーンの再開時に呼ばれます.
-- pauseした場合に、再開処理で呼ばれます.
---------------------------------------
function Scene:onResume(params)
    FunctionUtil.callExist(self.sceneHandler.onResume, params)
end

---------------------------------------
-- シーンの一時停止時に呼ばれます.
---------------------------------------
function Scene:onPause()
    FunctionUtil.callExist(self.sceneHandler.onPause)
end

---------------------------------------
-- シーンの停止時に呼ばれます.
-- 停止された後、他シーン遷移が完了した後に
-- onDestoryが呼ばれます.
---------------------------------------
function Scene:onStop()
    self._opened = false
    FunctionUtil.callExist(self.sceneHandler.onStop)
end

---------------------------------------
-- シーンの破棄時に呼ばれます.
-- この時点でシーンは破棄されて使用できなくなります.
---------------------------------------
function Scene:onDestroy()
    for i, layer in ipairs(self.layers) do
        layer:dispose()
    end
    FunctionUtil.callExist(self.sceneHandler.onDestroy)
    
    -- モジュールの削除
    unrequire(self.name)
end

---------------------------------------
-- フレーム毎の処理を行います.
---------------------------------------
function Scene:onEnterFrame(event)
    for i, layer in ipairs(self.layers) do
        layer:onEnterFrame(event)
    end
    FunctionUtil.callExist(self.sceneHandler.onEnterFrame, event)
end

---------------------------------------
-- キーボード入力時の処理を行います.
---------------------------------------
function Scene:onKeyboard(event)
    FunctionUtil.callExist(self.sceneHandler.onKeyboard, event)
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function Scene:onSceneTouchDown(event)
    self:onSceneTouchCommon(event, "onTouchDown")
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function Scene:onSceneTouchUp(event)
    self:onSceneTouchCommon(event, "onTouchUp")
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function Scene:onSceneTouchMove(event)
    self:onSceneTouchCommon(event, "onTouchMove")
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function Scene:onSceneTouchCancel(event)
    self:onSceneTouchCommon(event, "onTouchCancel")
end

---------------------------------------
-- 画面をタッチした時の共通処理です.
---------------------------------------
function Scene:onSceneTouchCommon(event, funcName)
    local max = #self.layers
    for i = max, 1, -1 do
        local layer = self.layers[i]
        if not event.stoped then
            layer[funcName](layer, event)
        end
    end
    if not event.stoped then
        if self[funcName] then
            self[funcName](self, event)
        end
    end
    if not event.stoped then
        FunctionUtil.callExist(self.sceneHandler[funcName], event)
    end
end

return Scene