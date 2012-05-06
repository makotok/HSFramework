local table = require("hs/lang/table")
local Logger = require("hs/core/Logger")
local Transform = require("hs/core/Transform")
local LayoutManager = require("hs/core/LayoutManager")
local Application = require("hs/core/Application")
local SceneManager

--------------------------------------------------------------------------------
-- 表示オブジェクトの基本クラスです.<br>
-- 描画の為の基本的な機能を有します.<br>
-- 直接的にこのクラスを使用する必要はありませんが、
-- 表示オブジェクトを追加したい場合にこのクラスを継承して使用します.
--
-- @class table
-- @name DisplayObject
--------------------------------------------------------------------------------

local M = Transform()

-- プロパティ定義
M:setPropertyName("width")
M:setPropertyName("height")
M:setPropertyName("depth")
M:setPropertyName("priority")
M:setPropertyName("alpha")
M:setPropertyName("red")
M:setPropertyName("green")
M:setPropertyName("blue")
M:setPropertyName("prop")
M:setPropertyName("deck")
M:setPropertyName("layer")
M:setPropertyName("nestLevel")
M:setPropertyName("visible", "setVisible", "isVisible")
M:setPropertyName("enabled", "setEnabled", "isEnabled")
M:setPropertyName("focus", "setFocus", "isFocus")

---------------------------------------
-- コンストラクタです
-- @name DisplayObject:new
---------------------------------------
function M:init(params)
    M:super(self)

    -- 変数
    self.name = ""
    self._deck = self:newDeck()
    self._prop = self:newProp(self.deck)
    self._width = 0
    self._height = 0
    self._depth = 0
    self._nestLevel = 1
    self._visible = true
    self._enabled = true
    self._focus = false
    self.application = Application

    -- 初期化イベント
    self:onInitial()

    -- propとディスプレイリストのひも付け
    if self.prop then
        self.prop._displayObject = self
    end
    
    -- 現在のシーンを設定
    SceneManager = SceneManager or require("hs/core/SceneManager")
    local scene = SceneManager.currentScene
    if scene then
        self.parent = scene
    end
    
    -- パラメータのコピー
    if params then
        table.copy(params, self)
    end
end

---------------------------------------
-- 初期化イベントハンドラです.
---------------------------------------
function M:onInitial()
end

---------------------------------------
-- validateDisplayをスケジューリングします.
---------------------------------------
function M:invalidateDisplay()
    if not self.invalidateDisplayFlag then
        self.invalidateDisplayFlag = true
        LayoutManager:invalidateDisplay(self)
    end
end

---------------------------------------
-- 表示オブジェクトの更新メソッドを呼び出します.
-- invalidateDisplay()をコールした場合に呼ばれます.
-- ライブラリ使用者が直接呼ぶ必要はありません.
---------------------------------------
function M:validateDisplay()
    self:updateDisplay()
    self.invalidateDisplayFlag = false
end

---------------------------------------
-- 表示オブジェクトを更新します.
-- invalidateDisplay()をコールした場合に呼ばれます.
-- ライブラリ使用者が直接呼ぶ必要はありません.
---------------------------------------
function M:updateDisplay()
end

---------------------------------------
-- MOAIDeckを生成します.
-- オーバーライドしてください.
-- デフォルトは適当です.
---------------------------------------
function M:newDeck()
    return MOAIScriptDeck.new()
end

---------------------------------------
-- MOAIPropを生成します.
-- オーバーライドしてください.
-- デフォルトは適当です.
---------------------------------------
function M:newProp(deck)
    local prop = MOAIProp.new()
    prop:setDeck(deck)
    return prop
end

---------------------------------------
--- MOAITransformを生成して返します.
---------------------------------------
function M:newTransformObj()
    return nil
end

---------------------------------------
-- 子オブジェクトの表示順を更新します.
---------------------------------------
function M:updatePriority()
    if not self.layer then
        return
    end
    
    local layer = self.layer
    self.priority = layer.nextPriority()
end

---------------------------------------
-- 描画順を返します.
---------------------------------------
function M:setPriority(priority)
    self.prop:setPriority(priority)
end

---------------------------------------
-- 描画順を返します.
---------------------------------------
function M:getPriority()
    return self.prop:getPriority()
end

---------------------------------------
-- サイズを設定します.
-- デフォルト動作では、deckに対してrectを設定する為、
-- 必要により継承して動作を変更する事を期待します.
---------------------------------------
function M:setSize(width, height)
    self._width = width
    self._height = height
    if self.deck then
        self.deck:setRect(0, 0, self.width, self.height)
        self:centerPivot()
    end
end

---------------------------------------
-- サイズを返します.
---------------------------------------
function M:getSize()
    return self._width, self._height
end

---------------------------------------
-- widthを設定します.
---------------------------------------
function M:setWidth(width)
    self:setSize(width, self._height)
end

---------------------------------------
-- widthを返します.
---------------------------------------
function M:getWidth()
    return self._width
end

---------------------------------------
-- heightを設定します.
---------------------------------------
function M:setHeight(height)
    self:setSize(self._width, height)
end

---------------------------------------
-- heightを返します.
---------------------------------------
function M:getHeight()
    return self._height
end

---------------------------------------
-- 中心点を中央に設定します.
---------------------------------------
function M:centerPivot()
    local w, h = self:getSize()
    local px = w / 2
    local py = h / 2
    self:setPivot(px, py, 0)
end

---------------------------------------
-- 色をアニメーション遷移させます.
---------------------------------------
function M:moveColor(red, green, blue, alpha, sec, mode, completeHandler)
    local action = self.prop:moveColor(red, green, blue, alpha, sec, mode)
    if completeHandler ~= nil then
        action:setListener(MOAIAction.EVENT_STOP, function(prop) completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- 色をアニメーション遷移させます.
---------------------------------------
function M:seekColor(red, green, blue, alpha, sec, mode, completeHandler)
    local action = self.prop:seekColor(red, green, blue, alpha, sec, mode)
    if completeHandler ~= nil then
        action:setListener(MOAIAction.EVENT_STOP, function(prop) completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- フェードインします.
---------------------------------------
function M:fadeIn(sec, mode, completeHandler)
    self.visible = true
    self:setColor(0, 0, 0, 0)
    local action = self.prop:moveColor(1, 1, 1, 1, sec, mode)
    if completeHandler ~= nil then
        action:setListener(MOAIAction.EVENT_STOP,
            function(prop)
                completeHandler(self)
            end
        )
    end
    return action
end

---------------------------------------
-- フェードアウトします.
---------------------------------------
function M:fadeOut(sec, mode, completeHandler)
    self:setColor(1, 1, 1, 1)
    self.visible = true
    local action = self.prop:seekColor(0, 0, 0, 0, sec, mode)
    if completeHandler ~= nil then
        action:setListener(MOAIAction.EVENT_STOP,
            function(prop)
                self.visible = false
                completeHandler(self)
            end
        )
    end
    return action
end

---------------------------------------
-- 色を設定します.
---------------------------------------
function M:setColor(red, green, blue, alpha)
    red = red and red or self.red
    green = green and green or self.green
    blue = blue and blue or self.blue
    alpha = alpha and alpha or self.alpha
    self.prop:setColor(red, green, blue, alpha)
end

---------------------------------------
-- alpha値を設定します.
---------------------------------------
function M:setAlpha(alpha)
    self:setColor(self.red, self.green, self.blue, alpha)
end

---------------------------------------
-- alpha値を返します.
---------------------------------------
function M:getAlpha()
    return self.prop:getAttr(MOAIColor.ATTR_A_COL)
end

---------------------------------------
-- red値を設定します.
---------------------------------------
function M:setRed(red)
    self:setColor(red, self.green, self.blue, self.alpha)
end

---------------------------------------
-- red値を返します.
---------------------------------------
function M:getRed()
    return self.prop:getAttr(MOAIColor.ATTR_R_COL)
end

---------------------------------------
-- green値を設定します.
---------------------------------------
function M:setGreen(green)
    self:setColor(self.red, green, self.blue, self.alpha)
end

---------------------------------------
-- green値を返します.
---------------------------------------
function M:getGreen()
    return self.prop:getAttr(MOAIColor.ATTR_G_COL)
end

---------------------------------------
-- blue値を設定します.
---------------------------------------
function M:setBlue(blue)
    self:setColor(self.red, self.green, blue, self.alpha)
end

---------------------------------------
-- blue値を返します.
---------------------------------------
function M:getBlue()
    return self.prop:getAttr(MOAIColor.ATTR_B_COL)
end

---------------------------------------
-- 表示するか設定します.
---------------------------------------
function M:setVisible(visible)
    self._visible = visible
    if self.prop then
        self.prop:setVisible(self.visible)
    end    
end

---------------------------------------
-- 表示するか返します.
---------------------------------------
function M:isVisible()
    return self._visible
end

---------------------------------------
-- 有効かどうか設定します.
---------------------------------------
function M:setEnabled(value)
    self._enabled = value
end

---------------------------------------
-- 有効かどうか返します.
---------------------------------------
function M:isEnabled()
    return self._enabled
end

---------------------------------------
-- フォーカスを設定します.
---------------------------------------
function M:setFocus(value)
    self._focus = value
end

---------------------------------------
-- フォーカスを返します.
---------------------------------------
function M:isFocus()
    return self._focus
end

---------------------------------------
-- レイヤーをセットします.
-- 描画オブジェクトをMOAILayerに追加します.
---------------------------------------
function M:setLayer(layer)
    local myLayer = self.layer
    if myLayer == layer then
        return
    end
    -- レイヤーから削除
    if myLayer ~= nil then
        myLayer:removeProp(self.prop)
    end
    -- レイヤーに追加
    self._layer = layer
    if layer then
        layer:addProp(self.prop)
    end
end

---------------------------------------
-- レイヤーを返します.
---------------------------------------
function M:getLayer(layer)
    return self._layer
end

---------------------------------------
-- MOAIDeckを設定します.
---------------------------------------
function M:setDeck(deck)
    self._deck = deck
end

---------------------------------------
-- MOAIDeckを返します.
---------------------------------------
function M:getDeck()
    return self._deck
end

---------------------------------------
-- MOAIPropを設定します.
---------------------------------------
function M:setProp(prop)
    self._prop = prop
end

---------------------------------------
-- MOAIPropを返します.
---------------------------------------
function M:getProp()
    return self._prop
end

---------------------------------------
-- オブジェクトのネストレベルを設定します.
---------------------------------------
function M:setNestLevel(value)
    self._nestLevel = value
end

---------------------------------------
-- オブジェクトのネストレベルを返します.
---------------------------------------
function M:getNestLevel()
    return self._nestLevel
end

---------------------------------------
-- MOAITransformを返します.
-- デフォルトではpropと同一を返します.
---------------------------------------
function M:getTransformObj()
    return self.prop
end

---------------------------------------
-- リソースを削除します.
---------------------------------------
function M:dispose()
    self.parent = nil
end

---------------------------------------
-- タッチ処理を行います.
---------------------------------------
function M:onTouchDown(event)
end

---------------------------------------
-- タッチ処理を行います.
---------------------------------------
function M:onTouchUp(event)
end

---------------------------------------
-- タッチ処理を行います.
---------------------------------------
function M:onTouchMove(event)
end

---------------------------------------
-- タッチ処理を行います.
---------------------------------------
function M:onTouchCancel(event)
end

return M
