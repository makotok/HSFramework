local EventDispatcher = require("hs/core/EventDispatcher")
local Scene -- 遅延してrequireします

--------------------------------------------------------------------------------
-- 表示オブジェクトの移動や回転、拡大を行うためのクラスです
-- @class table
-- @name Transform
--------------------------------------------------------------------------------
local Transform = EventDispatcher()

-- プロパティ定義
Transform:setPropertyName("x")
Transform:setPropertyName("y")
Transform:setPropertyName("z")
Transform:setPropertyName("worldX")
Transform:setPropertyName("worldY")
Transform:setPropertyName("worldZ")
Transform:setPropertyName("pivotX")
Transform:setPropertyName("pivotY")
Transform:setPropertyName("pivotZ")
Transform:setPropertyName("rotationX")
Transform:setPropertyName("rotationY")
Transform:setPropertyName("rotationZ")
Transform:setPropertyName("scaleX")
Transform:setPropertyName("scaleY")
Transform:setPropertyName("scaleZ")
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
function Transform:setLocation(x, y, z)
    z = z or 0
    local parent = self.parent
    if parent then
        x = x + parent.worldX
        y = y + parent.worldY
        z = z + parent.worldZ
    end
    self:setWorldLocation(x, y, z)
end

---------------------------------------
-- ローカル座標を返します.
-- @return x, y, z
---------------------------------------
function Transform:getLocation()
    local parent = self.parent
    local x, y, z = self:getWorldLocation()
    if parent then
        local worldX, worldY, worldZ = parent:getWorldLocation()
        x = x - worldX
        y = y - worldY
        z = z - worldZ
    end
    return x, y, z
end

---------------------------------------
-- ローカル座標を移動します.
-- @return action
---------------------------------------
function Transform:moveLocation(x, y, z, sec, mode, completeHandler)
    local action = self.transformObj:moveLoc(x, y, z, sec, mode)
    if completeHandler ~= nil then
        action:setListener(MOAIAction.EVENT_STOP, function(prop) completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- ローカル座標を移動します.
-- @return action
---------------------------------------
function Transform:seekLocation(x, y, z, sec, mode, completeHandler)
    local action = self.transformObj:seekLoc(x, y, z, sec, mode)
    if completeHandler ~= nil then
        action:setListener(MOAIAction.EVENT_STOP, function(prop) completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- ローカルX座標を設定します.
---------------------------------------
function Transform:setX(x)
    self:setLocation(x, self.y, self.z)
end

---------------------------------------
-- ローカルX座標を返します.
---------------------------------------
function Transform:getX()
    local x, y, z = self:getLocation()
    return x
end

---------------------------------------
-- ローカルY座標を設定します.
---------------------------------------
function Transform:setY(y)
    self:setLocation(self.x, y, self.z)
end

---------------------------------------
-- ローカルY座標を返します.
---------------------------------------
function Transform:getY()
    local x, y, z = self:getLocation()
    return y
end

---------------------------------------
-- ローカルZ座標を設定します.
---------------------------------------
function Transform:setZ(z)
    self:setLocation(self.x, self.y, z)
end

---------------------------------------
-- ローカルZ座標を返します.
---------------------------------------
function Transform:getZ()
    local x, y, z = self:getLocation()
    return z
end

---------------------------------------
-- ワールド座標を設定します.
---------------------------------------
function Transform:setWorldLocation(x, y, z)
    z = z or 0
    x = x + self.pivotX
    y = y + self.pivotY
    z = z + self.pivotZ
    self.transformObj:setLoc(x, y, z)
end

---------------------------------------
-- ワールド座標を返します.
---------------------------------------
function Transform:getWorldLocation()
    local x, y, z = self.transformObj:getLoc()
    x = x - self.pivotX
    y = y - self.pivotY
    z = z - self.pivotZ
    return x, y, z
end

---------------------------------------
-- ワールドX座標を設定します.
---------------------------------------
function Transform:setWorldX(x)
    self:setWorldLocation(x, self.worldY, self.worldZ)
end

---------------------------------------
-- ワールドX座標を返します.
---------------------------------------
function Transform:getWorldX()
    local x, y, z = self:getWorldLocation()
    return x
end

---------------------------------------
-- ワールドY座標を設定します.
---------------------------------------
function Transform:setWorldY(y)
    self:setWorldLocation(self.worldX, y, self.worldZ)
end

---------------------------------------
-- ワールドY座標を返します.
---------------------------------------
function Transform:getWorldY()
    local x, y, z = self:getWorldLocation()
    return y
end

---------------------------------------
-- ワールドZ座標を設定します.
---------------------------------------
function Transform:setWorldZ(z)
    self:setWorldLocation(self.worldX, self.worldY, z)
end

---------------------------------------
-- ワールドZ座標を返します.
---------------------------------------
function Transform:getWorldZ()
    local x, y, z = self:getWorldLocation()
    return z
end

---------------------------------------
-- 回転量を設定します.
---------------------------------------
function Transform:setRotation(rx, ry, rz)
    self.transformObj:setRot(rx, ry, rz)
end

---------------------------------------
-- 回転量を返します.
---------------------------------------
function Transform:getRotation()
    return self.transformObj:getRot()
end

---------------------------------------
-- 回転量Xを設定します.
---------------------------------------
function Transform:setRotationX(rx)
    self:setRotation(rx, self.rotationY, self.rotationZ)
end

---------------------------------------
-- 回転量Xを返します.
---------------------------------------
function Transform:getRotationX()
    local rx, ry, rz = self.transformObj:getRot()
    return rx
end

---------------------------------------
-- 回転量Yを設定します.
---------------------------------------
function Transform:setRotationY(ry)
    self:setRotation(self.rotationX, ry, self.rotationZ)
end

---------------------------------------
-- 回転量Yを返します.
---------------------------------------
function Transform:getRotationY()
    local rx, ry, rz = self.transformObj:getRot()
    return ry
end

---------------------------------------
-- 回転量Zを設定します.
---------------------------------------
function Transform:setRotationZ(rz)
    self:setRotation(self.rotationX, self.rotationY, rz)
end

---------------------------------------
-- 回転量Zを返します.
---------------------------------------
function Transform:getRotationZ()
    local rx, ry, rz = self.transformObj:getRot()
    return rz
end

---------------------------------------
-- 現在座標から回転します.
---------------------------------------
function Transform:moveRotation(rx, ry, rz, sec, mode, completeHandler)
    local action = self.transformObj:moveRot(rx, ry, rz, sec, mode)
    if completeHandler then
        action:setListener(MOAIAction.EVENT_STOP, function() completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- 最終地点に向かって回転します.
---------------------------------------
function Transform:seekRotation(rx, ry, rz, sec, mode, completeHandler)
    local action = self.transformObj:seekRot(rx, ry, rz, sec, mode)
    if completeHandler then
        action:setListener(MOAIAction.EVENT_STOP, function() completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- スケールを設定します.
-- @param scaleX 比率X
-- @param scaleY 比率Y
-- @param scaleZ 比率Z
---------------------------------------
function Transform:setScale(scaleX, scaleY, scaleZ)
    self.transformObj:setScl(scaleX, scaleY, scaleZ)
end

---------------------------------------
-- スケールを返します.
-- @return scaleX, scaleY, scaleZ
---------------------------------------
function Transform:getScale()
    return self.transformObj:getScl()
end

---------------------------------------
-- 現在位置からスケールを移動します.
---------------------------------------
function Transform:moveScale(x, y, z, sec, mode, completeHandler)
    local action = self.transformObj:moveScl(x, y, z, sec, mode)
    if completeHandler then
        action:setListener(MOAIAction.EVENT_STOP, function() completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- 最終地点にスケールを移動します.
---------------------------------------
function Transform:seekScale(x, y, z, sec, mode, completeHandler)
    local action = self.transformObj:seekScl(x, y, z, sec, mode)
    if completeHandler then
        action:setListener(MOAIAction.EVENT_STOP, function() completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- スケールXを設定します.
---------------------------------------
function Transform:setScaleX(scaleX)
    self:setScale(scaleX, self.scaleY, self.Z)
end

---------------------------------------
-- スケールXを返します.
---------------------------------------
function Transform:getScaleX()
    local scaleX, scaleY, scaleZ = self:getScale()
    return scaleX
end

---------------------------------------
-- スケールYを設定します.
---------------------------------------
function Transform:setScaleY(scaleY)
    self:setScale(self.scaleX, scaleY, self.scaleZ)
end

---------------------------------------
-- スケールYを返します.
---------------------------------------
function Transform:getScaleY()
    local scaleX, scaleY, scaleZ = self:getScale()
    return scaleY
end

---------------------------------------
-- スケールZを設定します.
---------------------------------------
function Transform:setScaleZ(scaleZ)
    self:setScale(self.scaleX, self.scaleY, scaleZ)
end

---------------------------------------
-- スケールZを返します.
---------------------------------------
function Transform:getScaleZ()
    local scaleX, scaleY, scaleZ = self:getScale()
    return scaleZ
end

---------------------------------------
-- 中心座標を設定します.
-- これは、回転やスケールで使用されます.
-- MOAIと違い、座標が変わりません.
---------------------------------------
function Transform:setPivot(pivotX, pivotY, pivotZ)
    local x, y, z = self:getWorldLocation()
    self.transformObj:setPiv(pivotX, pivotY, pivotZ)
    self:setWorldLocation(x, y, z)
end

---------------------------------------
-- 中心座標を返します.
---------------------------------------
function Transform:getPivot()
    return self.transformObj:getPiv()
end

---------------------------------------
-- 中心座標を設定します.
---------------------------------------
function Transform:setPivotX(pivotX)
    self:setPivot(pivotX, self.pivotY, self.pivotZ)
end

---------------------------------------
-- 中心座標Xを返します.
---------------------------------------
function Transform:getPivotX()
    local pivotX, pivotY, pivotZ = self:getPivot()
    return pivotX
end

---------------------------------------
-- 中心座標Yを設定します.
---------------------------------------
function Transform:setPivotY(pivotY)
    self:setPivot(self.pivotX, pivotY, self.pivotZ)
end

---------------------------------------
-- 中心座標Yを返します.
---------------------------------------
function Transform:getPivotY()
    local pivotX, pivotY, pivotZ = self:getPivot()
    return pivotY
end

---------------------------------------
-- 中心座標Zを設定します.
---------------------------------------
function Transform:setPivotZ(pivotZ)
    self:setPivot(self.pivotX, self.pivotY, pivotZ)
end

---------------------------------------
-- 中心座標Zを返します.
---------------------------------------
function Transform:getPivotZ()
    local pivotX, pivotY, pivotZ = self:getPivot()
    return pivotZ
end

---------------------------------------
-- 親オブジェクトを設定します.
-- 親オブジェクトはGroupである必要があります.
-- nilを設定した場合、親オブジェクトはクリアされます.
---------------------------------------
function Transform:setParent(parent)
    Scene = Scene or require("hs/core/Scene")
    
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
    local x, y, z = self:getLocation()
    
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
    self:setLocation(x, y, z)
end

---------------------------------------
-- 親オブジェクトを返します.
---------------------------------------
function Transform:getParent(parent)
    return self._parent
end

return Transform