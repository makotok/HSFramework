local EventDispatcher = require("hs/core/EventDispatcher")
local Scene -- 遅延してrequireします

--------------------------------------------------------------------------------
-- 表示オブジェクトの移動や回転、拡大を行うためのクラスです
-- @class table
-- @name Transform
--------------------------------------------------------------------------------
local M = EventDispatcher()

-- プロパティ定義
M:setPropertyName("x")
M:setPropertyName("y")
M:setPropertyName("z")
M:setPropertyName("pivotX")
M:setPropertyName("pivotY")
M:setPropertyName("pivotZ")
M:setPropertyName("rotationX")
M:setPropertyName("rotationY")
M:setPropertyName("rotationZ")
M:setPropertyName("scaleX")
M:setPropertyName("scaleY")
M:setPropertyName("scaleZ")
M:setPropertyName("parent")
M:setPropertyName("transformObj")

---------------------------------------
--- コンストラクタです
---------------------------------------
function M:init()
    M:super(self)

    -- 変数
    self._transformObj = self:newTransformObj()
end

---------------------------------------
--- MOAITransformを生成して返します.
---------------------------------------
function M:newTransformObj()
    return MOAITransform.new()
end

function M:getTransformObj()
    return self._transformObj
end

---------------------------------------
-- ローカル座標を設定します.
---------------------------------------
function M:setLocation(x, y, z)
    z = z or 0
    x = x + self.pivotX
    y = y + self.pivotY
    z = z + self.pivotZ
    self.transformObj:setLoc(x, y, z)
end

---------------------------------------
-- ローカル座標を返します.
-- @return x, y, z
---------------------------------------
function M:getLocation()
    local x, y, z = self.transformObj:getLoc()
    x = x - self.pivotX
    y = y - self.pivotY
    z = z - self.pivotZ
    return x, y, z
end

---------------------------------------
-- ローカル座標を移動します.
-- @return action
---------------------------------------
function M:moveLocation(x, y, z, sec, mode, completeHandler)
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
function M:seekLocation(x, y, z, sec, mode, completeHandler)
    local action = self.transformObj:seekLoc(x, y, z, sec, mode)
    if completeHandler ~= nil then
        action:setListener(MOAIAction.EVENT_STOP, function(prop) completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- ローカルX座標を設定します.
---------------------------------------
function M:setX(x)
    self:setLocation(x, self.y, self.z)
end

---------------------------------------
-- ローカルX座標を返します.
---------------------------------------
function M:getX()
    local x, y, z = self:getLocation()
    return x
end

---------------------------------------
-- ローカルY座標を設定します.
---------------------------------------
function M:setY(y)
    self:setLocation(self.x, y, self.z)
end

---------------------------------------
-- ローカルY座標を返します.
---------------------------------------
function M:getY()
    local x, y, z = self:getLocation()
    return y
end

---------------------------------------
-- ローカルZ座標を設定します.
---------------------------------------
function M:setZ(z)
    self:setLocation(self.x, self.y, z)
end

---------------------------------------
-- ローカルZ座標を返します.
---------------------------------------
function M:getZ()
    local x, y, z = self:getLocation()
    return z
end

---------------------------------------
-- 回転量を設定します.
---------------------------------------
function M:setRotation(rx, ry, rz)
    self.transformObj:setRot(rx, ry, rz)
end

---------------------------------------
-- 回転量を返します.
---------------------------------------
function M:getRotation()
    return self.transformObj:getRot()
end

---------------------------------------
-- 回転量Xを設定します.
---------------------------------------
function M:setRotationX(rx)
    self:setRotation(rx, self.rotationY, self.rotationZ)
end

---------------------------------------
-- 回転量Xを返します.
---------------------------------------
function M:getRotationX()
    local rx, ry, rz = self.transformObj:getRot()
    return rx
end

---------------------------------------
-- 回転量Yを設定します.
---------------------------------------
function M:setRotationY(ry)
    self:setRotation(self.rotationX, ry, self.rotationZ)
end

---------------------------------------
-- 回転量Yを返します.
---------------------------------------
function M:getRotationY()
    local rx, ry, rz = self.transformObj:getRot()
    return ry
end

---------------------------------------
-- 回転量Zを設定します.
---------------------------------------
function M:setRotationZ(rz)
    self:setRotation(self.rotationX, self.rotationY, rz)
end

---------------------------------------
-- 回転量Zを返します.
---------------------------------------
function M:getRotationZ()
    local rx, ry, rz = self.transformObj:getRot()
    return rz
end

---------------------------------------
-- 現在座標から回転します.
---------------------------------------
function M:moveRotation(rx, ry, rz, sec, mode, completeHandler)
    local action = self.transformObj:moveRot(rx, ry, rz, sec, mode)
    if completeHandler then
        action:setListener(MOAIAction.EVENT_STOP, function() completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- 最終地点に向かって回転します.
---------------------------------------
function M:seekRotation(rx, ry, rz, sec, mode, completeHandler)
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
function M:setScale(scaleX, scaleY, scaleZ)
    self.transformObj:setScl(scaleX, scaleY, scaleZ)
end

---------------------------------------
-- スケールを返します.
-- @return scaleX, scaleY, scaleZ
---------------------------------------
function M:getScale()
    return self.transformObj:getScl()
end

---------------------------------------
-- 現在位置からスケールを移動します.
---------------------------------------
function M:moveScale(x, y, z, sec, mode, completeHandler)
    local action = self.transformObj:moveScl(x, y, z, sec, mode)
    if completeHandler then
        action:setListener(MOAIAction.EVENT_STOP, function() completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- 最終地点にスケールを移動します.
---------------------------------------
function M:seekScale(x, y, z, sec, mode, completeHandler)
    local action = self.transformObj:seekScl(x, y, z, sec, mode)
    if completeHandler then
        action:setListener(MOAIAction.EVENT_STOP, function() completeHandler(self) end)
    end
    return action
end

---------------------------------------
-- スケールXを設定します.
---------------------------------------
function M:setScaleX(scaleX)
    self:setScale(scaleX, self.scaleY, self.Z)
end

---------------------------------------
-- スケールXを返します.
---------------------------------------
function M:getScaleX()
    local scaleX, scaleY, scaleZ = self:getScale()
    return scaleX
end

---------------------------------------
-- スケールYを設定します.
---------------------------------------
function M:setScaleY(scaleY)
    self:setScale(self.scaleX, scaleY, self.scaleZ)
end

---------------------------------------
-- スケールYを返します.
---------------------------------------
function M:getScaleY()
    local scaleX, scaleY, scaleZ = self:getScale()
    return scaleY
end

---------------------------------------
-- スケールZを設定します.
---------------------------------------
function M:setScaleZ(scaleZ)
    self:setScale(self.scaleX, self.scaleY, scaleZ)
end

---------------------------------------
-- スケールZを返します.
---------------------------------------
function M:getScaleZ()
    local scaleX, scaleY, scaleZ = self:getScale()
    return scaleZ
end

---------------------------------------
-- 中心座標を設定します.
-- これは、回転やスケールで使用されます.
-- MOAIと違い、座標が変わりません.
---------------------------------------
function M:setPivot(pivotX, pivotY, pivotZ)
    local x, y, z = self:getLocation()
    self.transformObj:setPiv(pivotX, pivotY, pivotZ)
    self:setLocation(x, y, z)
end

---------------------------------------
-- 中心座標を返します.
---------------------------------------
function M:getPivot()
    return self.transformObj:getPiv()
end

---------------------------------------
-- 中心座標を設定します.
---------------------------------------
function M:setPivotX(pivotX)
    self:setPivot(pivotX, self.pivotY, self.pivotZ)
end

---------------------------------------
-- 中心座標Xを返します.
---------------------------------------
function M:getPivotX()
    local pivotX, pivotY, pivotZ = self:getPivot()
    return pivotX
end

---------------------------------------
-- 中心座標Yを設定します.
---------------------------------------
function M:setPivotY(pivotY)
    self:setPivot(self.pivotX, pivotY, self.pivotZ)
end

---------------------------------------
-- 中心座標Yを返します.
---------------------------------------
function M:getPivotY()
    local pivotX, pivotY, pivotZ = self:getPivot()
    return pivotY
end

---------------------------------------
-- 中心座標Zを設定します.
---------------------------------------
function M:setPivotZ(pivotZ)
    self:setPivot(self.pivotX, self.pivotY, pivotZ)
end

---------------------------------------
-- 中心座標Zを返します.
---------------------------------------
function M:getPivotZ()
    local pivotX, pivotY, pivotZ = self:getPivot()
    return pivotZ
end

---------------------------------------
-- 親オブジェクトを設定します.
-- 親オブジェクトはGroupである必要があります.
-- nilを設定した場合、親オブジェクトはクリアされます.
---------------------------------------
function M:setParent(parent)
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
    
    -- 親から削除
    if myParent ~= nil then
        myParent:removeChild(self)
    end

    -- 親に追加
    self._parent = parent
    if parent ~= nil then
        parent:addChild(self)
    end
end

---------------------------------------
-- 親オブジェクトを返します.
---------------------------------------
function M:getParent(parent)
    return self._parent
end

return M