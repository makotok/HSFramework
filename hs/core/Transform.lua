--------------------------------------------------------------------------------
-- 表示オブジェクトの移動や回転、拡大を行うためのクラスです
-- @class table
-- @name Transform
--------------------------------------------------------------------------------
Transform = EventDispatcher()

-- プロパティ定義
Transform:setPropertyName("x")
Transform:setPropertyName("y")
Transform:setPropertyName("worldX")
Transform:setPropertyName("worldY")
Transform:setPropertyName("pivotX")
Transform:setPropertyName("pivotY")
Transform:setPropertyName("rotation")
Transform:setPropertyName("scaleX")
Transform:setPropertyName("scaleY")
Transform:setPropertyName("parent")
Transform:setPropertyName("transformObj")

---------------------------------------
--- コンストラクタです
---------------------------------------
function Transform:init()
    Transform:super(self)

    -- 変数
    self._transformObj = self:newTransformObj()
end

---------------------------------------
--- MOAITransformを生成して返します.
---------------------------------------
function Transform:newTransformObj()
    return MOAITransform.new()
end

function Transform:getTransformObj()
    return self._transformObj
end

---------------------------------------
-- ローカル座標を設定します.
---------------------------------------
function Transform:setLocation(x, y)
    local parent = self.parent
    if parent then
        x = x + parent.worldX
        y = y + parent.worldY
    end
    self:setWorldLocation(x, y)
end

---------------------------------------
-- ローカル座標を返します.
---------------------------------------
function Transform:getLocation()
    local parent = self.parent
    local x, y = self:getWorldLocation()
    if parent then
        local worldX, worldY = parent:getWorldLocation()
        x = x - worldX
        y = y - worldY
    end
    return x, y
end

---------------------------------------
-- ローカル座標を移動します.
---------------------------------------
function Transform:move(x, y, sec, mode, completeHandler)
    Log.debug(x, y, mode)
    local action = self.transformObj:moveLoc(x, y, sec, mode)
    if completeHandler ~= nil then
        action:setListener(MOAIAction.EVENT_STOP, function(prop) completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- ローカルX座標を設定します.
---------------------------------------
function Transform:setX(x)
    self:setLocation(x, self.y)
end

---------------------------------------
-- ローカルX座標を返します.
---------------------------------------
function Transform:getX()
    local x, y = self:getLocation()
    return x
end

---------------------------------------
-- ローカルY座標を設定します.
---------------------------------------
function Transform:setY(y)
    self:setLocation(self.x, y)
end

---------------------------------------
-- ローカルY座標を返します.
---------------------------------------
function Transform:getY()
    local x, y = self:getLocation()
    return y
end

---------------------------------------
-- ワールド座標を設定します.
---------------------------------------
function Transform:setWorldLocation(x, y)
    x = x + self.pivotX
    y = y + self.pivotY
    self.transformObj:setLoc(x, y)
end

---------------------------------------
-- ワールド座標を返します.
---------------------------------------
function Transform:getWorldLocation()
    local x, y = self.transformObj:getLoc()
    x = x - self.pivotX
    y = y - self.pivotY
    return x, y
end


---------------------------------------
-- ワールドX座標を設定します.
---------------------------------------
function Transform:setWorldX(x)
    self:setWorldLocation(x, self.y)
end

---------------------------------------
-- ワールドX座標を返します.
---------------------------------------
function Transform:getWorldX()
    local x, y = self:getWorldLocation()
    return x
end

---------------------------------------
-- ワールドY座標を設定します.
---------------------------------------
function Transform:setWorldY(y)
    self:setWorldLocation(self.x, y)
end

---------------------------------------
-- ワールドY座標を返します.
---------------------------------------
function Transform:getWorldY()
    local x, y = self:getWorldLocation()
    return y
end

---------------------------------------
-- rotationを設定します.
---------------------------------------
function Transform:setRotation(rotation)
    self.transformObj:setRot(rotation)
end

---------------------------------------
-- rotationを返します.
---------------------------------------
function Transform:getRotation()
    return self.transformObj:getRot()
end

---------------------------------------
-- 回転します.
---------------------------------------
function Transform:rotate(rotation, sec, mode, completeHandler)
    local action = self.transformObj:moveRot(rotation, sec, mode)
    if completeHandler then
        action:setListener(MOAIAction.EVENT_STOP, function() completeHandler(self) end)
    end
    return action
end


---------------------------------------
-- scaleX, scaleYを設定します.
---------------------------------------
function Transform:setScale(scaleX, scaleY)
    self.transformObj:setScl(scaleX, scaleY)
end

---------------------------------------
-- scaleX, scaleYを返します.
---------------------------------------
function Transform:getScale()
    return self.transformObj:getScl()
end

---------------------------------------
-- 回転量を移動します.
---------------------------------------
function Transform:scale(x, y, sec, mode, completeHandler)
    local action = self.transformObj:moveScl(x, y, sec, mode)
    if completeHandler then
        action:setListener(MOAIAction.EVENT_STOP, function() completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- scaleXを設定します.
---------------------------------------
function Transform:setScaleX(scaleX)
    self:setScale(scaleX, self.scaleY)
end

---------------------------------------
-- scaleXを返します.
---------------------------------------
function Transform:getScaleX()
    local scaleX, scaleY = self:getScale()
    return scaleX
end

---------------------------------------
-- scaleYを設定します.
---------------------------------------
function Transform:setScaleY(scaleY)
    self:setScale(self.scaleX, scaleY)
end

---------------------------------------
-- scaleYを返します.
---------------------------------------
function Transform:getScaleY()
    local scaleX, scaleY = self:getScale()
    return scaleY
end

---------------------------------------
-- 中心点を設定します.
-- これは、回転や拡大・縮小で使用されます.
---------------------------------------
function Transform:setPivot(pivotX, pivotY)
    local x, y = self:getWorldLocation()
    self.transformObj:setPiv(pivotX, pivotY)
    self:setWorldLocation(x, y)
end

---------------------------------------
-- 中心点を返します.
---------------------------------------
function Transform:getPivot()
    return self.transformObj:getPiv()
end

---------------------------------------
-- 中心点を設定します.
-- これは、回転や拡大・縮小で使用されます.
---------------------------------------
function Transform:setPivotX(pivotX)
    self:setPivot(pivotX, self.pivotY)
end

---------------------------------------
-- pivotXを返します.
---------------------------------------
function Transform:getPivotX()
    local pivotX, pivotY = self:getPivot()
    return pivotX
end

---------------------------------------
-- 中心点を設定します.
-- これは、回転や拡大・縮小で使用されます.
---------------------------------------
function Transform:setPivotY(pivotY)
    self:setPivot(self.pivotX, pivotY)
end

---------------------------------------
-- pivotYを返します.
---------------------------------------
function Transform:getPivotY()
    local pivotX, pivotY = self:getPivot()
    return pivotY
end

---------------------------------------
-- 親オブジェクトを設定します.
-- 親オブジェクトはGroupである必要があります.
-- nilを設定した場合、親オブジェクトはクリアされます.
---------------------------------------
function Transform:setParent(parent)
    -- sceneを指定された場合はtopLayerを取得
    if parent and parent:instanceOf(Scene) then
        parent = parent.topLayer
    end

    -- 親が同一の場合は処理しない
    local myParent = self.parent
    if myParent == parent then
        return
    end
    
    -- 現在の相対座標を取得
    local x, y = self:getLocation()
    
    -- 親から削除
    if myParent ~= nil then
        myParent:removeChild(self)
    end

    -- 親に追加
    self._parent = parent
    if parent ~= nil then
        parent:addChild(self)
    end
    
    -- 相対座標を元に戻す
    self:setLocation(x, y)
end

---------------------------------------
-- 親オブジェクトを返します.
---------------------------------------
function Transform:getParent(parent)
    return self._parent
end

