--------------------------------------------------------------------------------
-- 表示オブジェクトの基本クラスです。
-- 描画の為の基本的な機能を有します。
--
--------------------------------------------------------------------------------

require "hs/EventDispatcher"

DisplayObject = Transform()

-- プロパティ定義
DisplayObject:setPropertyName("width")
DisplayObject:setPropertyName("height")
DisplayObject:setPropertyName("priority")
DisplayObject:setPropertyName("parent")
DisplayObject:setPropertyName("physicsObject")
DisplayObject:setPropertyName("alpha")
DisplayObject:setPropertyName("red")
DisplayObject:setPropertyName("green")
DisplayObject:setPropertyName("blue")
DisplayObject:setPropertyName("prop")
DisplayObject:setPropertyName("deck")
DisplayObject:setPropertyName("layer")
DisplayObject:setPropertyName("visible", "setVisible", "isVisible")
DisplayObject:setPropertyName("enabled", "setEnabled", "isEnabled")
DisplayObject:setPropertyName("focus", "setFocus", "isFocus")

---------------------------------------
--- コンストラクタです
---------------------------------------
function DisplayObject:init()
    DisplayObject:super(self)

    -- 変数
    self.name = ""
    self._deck = self:newDeck()
    self._prop = self:newProp(self.deck)
    self._width = 0
    self._height = 0
    self._visible = true
    self._enabled = true
    self._focus = false
end

---------------------------------------
-- MOAIDeckを生成します。
-- オーバーライドしてください。
-- デフォルトは適当です。
---------------------------------------
function DisplayObject:newDeck()
    return MOAIScriptDeck.new()
end

---------------------------------------
-- MOAIPropを生成します。
-- オーバーライドしてください。
-- デフォルトは適当です。
---------------------------------------
function DisplayObject:newProp(deck)
    local prop = MOAIProp2D.new()
    prop:setDeck(deck)
    return prop
end

---------------------------------------
--- MOAITransformを生成して返します。
---------------------------------------
function DisplayObject:newTransformObj()
    return nil
end

---------------------------------------
-- 描画順を設定します。
---------------------------------------
function DisplayObject:setPriority(priority)
    self.prop:setPriority(priority)
end

---------------------------------------
-- 描画順を返します。
---------------------------------------
function DisplayObject:setPriority(priority)
    return self.prop:getPriority()
end

---------------------------------------
-- サイズを設定します。
---------------------------------------
function DisplayObject:setSize(width, height)
    self._width = width
    self._height = height
    if self.deck then
        self.deck:setRect(0, 0, self.width, self.height)
        self:centerPivot()
    end
end

---------------------------------------
-- サイズを返します。
---------------------------------------
function DisplayObject:getSize()
    return self._width, self._height
end

---------------------------------------
-- widthを設定します。
---------------------------------------
function DisplayObject:setWidth(width)
    self:setSize(width, self._height)
end

---------------------------------------
-- widthを返します。
---------------------------------------
function DisplayObject:getWidth()
    return self._width
end

---------------------------------------
-- heightを設定します。
---------------------------------------
function DisplayObject:setHeight(height)
    self:setSize(self._width, height)
end

---------------------------------------
-- heightを返します。
---------------------------------------
function DisplayObject:getHeight()
    return self._height
end

---------------------------------------
-- 中心点を中央に設定します。
---------------------------------------
function DisplayObject:centerPivot()
    local w, h = self:getSize()
    local px = w / 2
    local py = h / 2
    self:setPivot(px, py)
end

---------------------------------------
-- 色を設定します。
---------------------------------------
function DisplayObject:setColor(red, green, blue, alpha)
    red = red and red or self.red
    green = green and green or self.green
    blue = blue and blue or self.blue
    alpha = alpha and alpha or self.alpha
    self.prop:setColor(red, green, blue, alpha)
end

---------------------------------------
-- alpha値を設定します。
---------------------------------------
function DisplayObject:setAlpha(alpha)
    self:setColor(self.red, self.green, self.blue, alpha)
end

---------------------------------------
-- alpha値を返します。
---------------------------------------
function DisplayObject:getAlpha()
    return self.prop:getAttr(MOAIColor.ATTR_A_COL)
end

---------------------------------------
-- red値を設定します。
---------------------------------------
function DisplayObject:setRed(red)
    self:setColor(red, self.green, self.blue, self.alpha)
end

---------------------------------------
-- red値を返します。
---------------------------------------
function DisplayObject:getRed()
    return self.prop:getAttr(MOAIColor.ATTR_R_COL)
end

---------------------------------------
-- green値を設定します。
---------------------------------------
function DisplayObject:setGreen(green)
    self:setColor(self.red, green, self.blue, self.alpha)
end

---------------------------------------
-- green値を返します。
---------------------------------------
function DisplayObject:getGreen()
    return self.prop:getAttr(MOAIColor.ATTR_G_COL)
end

---------------------------------------
-- blue値を設定します。
---------------------------------------
function DisplayObject:setBlue(blue)
    self:setColor(self.red, self.green, blue, self.alpha)
end

---------------------------------------
-- blue値を返します。
---------------------------------------
function DisplayObject:getBlue()
    return self.prop:getAttr(MOAIColor.ATTR_B_COL)
end

---------------------------------------
-- 表示するか設定します。
---------------------------------------
function DisplayObject:setVisible(visible)
    self._visible = visible
    if self.prop then
        self.prop:setVisible(visible)
    end
end

---------------------------------------
-- 表示するか返します。
---------------------------------------
function DisplayObject:isVisible()
    return self._visible
end

---------------------------------------
-- 有効かどうか設定します。
---------------------------------------
function DisplayObject:setEnabled(value)
    self._enabled = value
end

---------------------------------------
-- 有効かどうか返します。
---------------------------------------
function DisplayObject:isEnabled()
    return self._enabled
end

---------------------------------------
-- フォーカスを設定します。
---------------------------------------
function DisplayObject:setFocus(value)
    self._focus = value
end

---------------------------------------
-- フォーカスを返します。
---------------------------------------
function DisplayObject:isFocus()
    return self._focus
end

---------------------------------------
-- 親オブジェクトを設定します。
-- 親オブジェクトはGroupである必要があります。
-- nilを設定した場合、親オブジェクトはクリアされます。
---------------------------------------
function DisplayObject:setParent(parent)    
    -- sceneを指定された場合はtopLayerを取得
    if parent and parent:instanceOf(Scene) then
        parent = parent.topLayer
    end

    local myParent = self.parent
    if myParent == parent then
        return
    end

    -- 親から削除
    if myParent ~= nil then
        myParent:removeChild(self)
    end

    -- 親に追加
    self._parent = parent
    if parent ~= nil then
        parent:addChild(self)
    end
    
    -- 座標等の連携
    if parent == nil or parent:instanceOf(Layer) then
        self.transformObj:setParent(nil)
    else
        self.transformObj:setParent(parent.transformObj)
    end
    if self.physicsObject then
        self.transformObj:setParent(self.physicsObject)
    end

end

---------------------------------------
-- 親オブジェクトを返します。
---------------------------------------
function DisplayObject:getParent(parent)
    return self._parent
end


---------------------------------------
-- 物理オブジェクトを設定します。
-- TODO:未実装
---------------------------------------
function DisplayObject:setPhysicsObject(object)
    self._physicsObject = object
end

---------------------------------------
-- 物理オブジェクトを返します。
-- TODO:未実装
---------------------------------------
function DisplayObject:getPhysicsObject()
    return self._physicsObject
end

---------------------------------------
-- レイヤーをセットします。
-- 描画オブジェクトをMOAILayerに追加します。
---------------------------------------
function DisplayObject:setLayer(layer)
    local myLayer = self.layer
    if myLayer == layer then
        return
    end
    -- レイヤーから削除
    if myLayer ~= nil then
        myLayer:removeProp(self.prop)
    end
    -- レイヤーに追加
    if layer then
        self._layer = layer
        layer:addProp(self.prop)
    end
end

---------------------------------------
-- レイヤーを返します。
---------------------------------------
function DisplayObject:getLayer(layer)
    return self._layer
end

---------------------------------------
-- MOAIDeckを設定します。
---------------------------------------
function DisplayObject:setDeck(deck)
    self._deck = deck
end

---------------------------------------
-- MOAIDeckを返します。
---------------------------------------
function DisplayObject:getDeck()
    return self._deck
end

---------------------------------------
-- MOAIPropを設定します。
---------------------------------------
function DisplayObject:setProp(prop)
    self._prop = prop
end

---------------------------------------
-- MOAIPropを返します。
---------------------------------------
function DisplayObject:getProp()
    return self._prop
end

---------------------------------------
-- MOAITransformを返します。
-- デフォルトではpropと同一を返します。
---------------------------------------
function DisplayObject:getTransformObj()
    return self.prop
end

