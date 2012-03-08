--------------------------------------------------------------------------------
-- 表示オブジェクトの基本クラスです。
-- 描画の為の基本的な機能を有します。
--------------------------------------------------------------------------------

DisplayObject = Transform()

-- プロパティ定義
DisplayObject:setPropertyName("width")
DisplayObject:setPropertyName("height")
DisplayObject:setPropertyName("priority")
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
    
    -- propとディスプレイリストのひも付け
    if self.prop then
        self.prop._displayObject = self
    end
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
-- 子オブジェクトの表示順を更新します。
---------------------------------------
function DisplayObject:updatePriority()
    if not self.layer then
        return
    end
    
    local layer = self.layer
    self.priority = layer.nextPriority()
end

---------------------------------------
-- 描画順を返します。
---------------------------------------
function DisplayObject:setPriority(priority)
    self.prop:setPriority(priority)
end

---------------------------------------
-- 描画順を返します。
---------------------------------------
function DisplayObject:getPriority()
    return self.prop:getPriority()
end

---------------------------------------
-- サイズを設定します。
-- デフォルト動作では、deckに対してrectを設定する為、
-- 必要により継承して動作を変更する事を期待します。
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
-- 色をアニメーション遷移させます。
---------------------------------------
function DisplayObject:moveColor(red, green, blue, alpha, sec, mode, completeHandler)
    local action = self.prop:moveColor(red, green, blue, alpha, sec, mode)
    if completeHandler ~= nil then
        action:setListener(MOAIAction.EVENT_STOP, function(prop) completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- フェードインします。
---------------------------------------
function DisplayObject:fadeIn(sec, mode, completeHandler)
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
-- フェードアウトします。
---------------------------------------
function DisplayObject:fadeOut(sec, mode, completeHandler)
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
-- 表示するか反映します。
---------------------------------------
function DisplayObject:updateVisible()
    -- FIXME:MOAIProp2D Bug?
    if self.prop then
        self.prop:setVisible(self.visible)
    end    
end

---------------------------------------
-- 表示するか設定します。
---------------------------------------
function DisplayObject:setVisible(visible)
    self._visible = visible
    self:updateVisible()
end

---------------------------------------
-- 表示するか返します。
---------------------------------------
function DisplayObject:isVisible()
    --[[
    if self._visible == false then
        return false
    end
    if self.parent then
        return self.parent:isVisible()
    end
    --]]
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
    self._layer = layer
    if layer then
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

---------------------------------------
-- リソースを削除します。
---------------------------------------
function DisplayObject:dispose()
    self.parent = nil
end

---------------------------------------
-- フレーム毎の処理を行います。
-- デフォルトでは、何も行いません。
---------------------------------------
function DisplayObject:onEnterFrame(event)
end

---------------------------------------
-- タッチ処理を行います。
-- デフォルトでは、何も行いません。
---------------------------------------
function DisplayObject:onTouchDown(event)
end

---------------------------------------
-- フレーム毎の処理を行います。
-- デフォルトでは、何も行いません。
---------------------------------------
function DisplayObject:onTouchUp(event)
end

---------------------------------------
-- フレーム毎の処理を行います。
-- デフォルトでは、何も行いません。
---------------------------------------
function DisplayObject:onTouchMove(event)
end

---------------------------------------
-- フレーム毎の処理を行います。
-- デフォルトでは、何も行いません。
---------------------------------------
function DisplayObject:onTouchCancel(event)
end