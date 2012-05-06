local table = require("hs/lang/table")
local Logger = require("hs/core/Logger")
local Event = require("hs/core/Event")
local Group = require("hs/core/Group")
local Transform = require("hs/core/Transform")
local Camera = require("hs/core/Camera")
local Application = require("hs/core/Application")

--------------------------------------------------------------------------------
-- シーンに追加できるレイヤークラスです
-- レイヤーは、ビューポートを持ち、MOAILayerに対応するクラスとなります.
--
-- レイヤー内の子オブジェクトの移動は、カメラを使用して移動してください.
-- レイヤーの直接的な移動は、画面内の座標を移動する事になります.
-- @class table
-- @name Layer
--------------------------------------------------------------------------------

local M = Group()

-- プロパティ定義
M:setPropertyName("camera")
M:setPropertyName("touchEnabled")
M:setPropertyName("renderPass")
M:setPropertyName("viewport")
M:setPropertyName("lastPriority")
M:setPropertyName("touchEnabled", "setTouchEnabled", "isTouchEnabled")

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(params)
    M:super(self, params)
end

function M:onInitial()
    Group.onInitial(self)
    
    self._renderPass = self:newRenderPass()
    self._partition = self.renderPass:getPartition()
    self._lastPriority = 0
    self._touchEnabled = true
    self._priorityChanged = false
    self.camera = Camera:new()
    self.camera:setPivot(Application.stageWidth / 2, Application.stageHeight / 2)
end

---------------------------------------
-- MOAILayerを生成します.
---------------------------------------
function M:newRenderPass()
    local layer = MOAILayer.new ()
    layer.viewport = MOAIViewport.new()
    layer.viewport:setOffset(-1, 1)
    layer.viewport:setScale(Application.window.width, -Application.window.height)
    layer.viewport:setSize(Application.stageWidth, Application.stageHeight)
    
    layer:setViewport(layer.viewport)
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    layer:setPartition(MOAIPartition.new())
    return layer
end

---------------------------------------
-- 親オブジェクトを設定します.
-- 親オブジェクトはSceneである必要があります.
-- nilを設定した場合、親オブジェクトはクリアされます.
---------------------------------------
function M:setParent(parent)
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
    if parent then
        parent:addChild(self)
    end
end

---------------------------------------
-- 子オブジェクトの属性連携を設定します.
---------------------------------------
function M:setAttrLinkForChild(child)
    --[[
    child.prop:clearAttrLink(MOAIColor.INHERIT_COLOR)
    if child.parent then
        child.prop:setAttrLink(MOAIColor.INHERIT_COLOR, child.parent.prop, MOAIColor.COLOR_TRAIT)
    end
    --]]
end

---------------------------------------
-- 子オブジェクトを追加します.
---------------------------------------
function M:addChild(child)
    Group.addChild(self, child)
    child.layer = self
end

---------------------------------------
-- 描画オブジェクトを追加します.
---------------------------------------
function M:addProp(prop)
    self.renderPass:insertProp(prop)
    self._priorityChanged = true
    self:invalidateDisplay()
end

---------------------------------------
-- 描画オブジェクトを削除します.
---------------------------------------
function M:removeProp(prop)
    self.renderPass:removeProp(prop)
end

---------------------------------------
-- レンダラーパスを返します.
---------------------------------------
function M:getRenderPass()
    return self._renderPass
end

---------------------------------------
-- Viewportを返します.
---------------------------------------
function M:getViewport()
    return self._renderPass.viewport
end

---------------------------------------
-- MOAIPropを返します.
---------------------------------------
function M:getProp()
    return self.renderPass
end

---------------------------------------
-- カメラを設定します.
---------------------------------------
function M:setCamera(camera)
    self._camera = camera
    self.renderPass:setCamera(camera.transformObj)
end

---------------------------------------
-- カメラを返します.
---------------------------------------
function M:getCamera()
    return self._camera
end

---------------------------------------
-- タッチ可能かどうか設定します.
---------------------------------------
function M:setTouchEnabled(enabled)
    self._touchEnabled = enabled
end

---------------------------------------
-- タッチ可能かどうか返します.
---------------------------------------
function M:isTouchEnabled()
    return self._touchEnabled
end

---------------------------------------
-- フレーム毎の処理を行います.
-- invalidateDisplayList関数が呼ばれていた場合、
-- updateDisplayList関数を実行します.
---------------------------------------
function M:onEnterFrame(event)
end

function M:updateDisplay()
    Group.updateDisplay(self)
    if self._priorityChanged then
        self._lastPriority = 0
        self:updatePriority()
        self._priorityChanged = false
    end
end

---------------------------------------
-- 次のプライオリティを採番して返します.
---------------------------------------
function M:nextPriority()
    self._lastPriority = self._lastPriority + 1
    return self._lastPriority
end

---------------------------------------
-- 最後のプライオリティを返します.
---------------------------------------
function M:lastPriority()
    return self._lastPriority
end

---------------------------------------
-- レイヤー内のワールド座標から、
-- 存在するDisplayObjectリストを返します.
---------------------------------------
function M:getDisplayListForPoint(worldX, worldY, worldZ)
    local partition = self._partition
    local array = {}
    local props = {partition:propListForPoint(worldX, worldY, worldZ or 0)}
    for i, prop in ipairs(props) do
        if prop._displayObject then
            table.insert(array, prop._displayObject)
        end
    end
    return array
end

---------------------------------------
-- スクリーン座標からワールド座標に変換します.
---------------------------------------
function M:windowToWorld(windowX, windowY, windowZ)
    return self.renderPass:wndToWorld(windowX, windowY, windowZ or 0)
end

---------------------------------------
-- ワールド座標からスクリーン座標に変換します.
---------------------------------------
function M:worldToWindow(worldX, worldY, worldZ)
    return self.renderPass:worldToWnd(worldX, worldY, worldZ or 0)
end

---------------------------------------
-- レイヤーのタッチする処理を行います.
---------------------------------------
function M:onTouchDown(event)
    if not self.touchEnabled then
        return
    end
    
    local worldX, worldY, worldZ = self:windowToWorld(event.x, event.y, 0)
    local displayList = self:getDisplayListForPoint(worldX, worldY, worldZ)
    self._touchDownDisplayList = displayList
    local max = #displayList

    self._touchDownDisplayList = displayList
    local e = Event:new(event.type)
    e.worldX = worldX
    e.worldY = worldY
    e.worldZ = worldZ
    
    for i = max, 1, -1 do
        local display = displayList[i]
        display:onTouchDown(e)
        if e.stoped then
            break
        end
    end
    if not e.stoped then
        self:dispatchEvent(e)
    end
end

---------------------------------------
-- レイヤーのタッチする処理を行います.
---------------------------------------
function M:onTouchUp(event)
    self:onTouchCommon(event, "onTouchUp")
end

---------------------------------------
-- レイヤーのタッチする処理を行います.
---------------------------------------
function M:onTouchMove(event)
    self:onTouchCommon(event, "onTouchMove")
end

---------------------------------------
-- レイヤーのタッチする処理を行います.
---------------------------------------
function M:onTouchCancel(event)
    self:onTouchCommon(event, "onTouchCancel")
end

---------------------------------------
-- レイヤーのタッチする共通処理です.
---------------------------------------
function M:onTouchCommon(event, funcName)
    if not self.touchEnabled then
        return
    end

    if not self._touchDownDisplayList then
        return
    end

    -- ワールド座標の取得
    local e = Event:new(event.type)
    e.screenX, e.screenY = event.x, event.y
    e.worldX, e.worldY, e.worldZ = self:windowToWorld(event.x, event.y, 0)
    
    local displayList = self._touchDownDisplayList
    local max = #displayList
    
    for i = max, 1, -1 do
        local display = displayList[i]
        display[funcName](display, e)
        if e.stoped then
            break
        end
    end
    if not e.stoped then
        self:dispatchEvent(e)
    end
end

return M