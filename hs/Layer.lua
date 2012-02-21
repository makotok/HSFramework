--------------------------------------------------------------------------------
-- シーンに追加できるレイヤークラスです
-- レイヤーは、ビューポートを持ち、MOAILayer2Dに対応するクラスとなります。
--
-- レイヤー内の子オブジェクトの移動は、カメラを使用して移動してください。
-- レイヤーの直接的な移動は、画面内の座標を移動する事になります。
--------------------------------------------------------------------------------

Layer = Group()

-- プロパティ定義
Layer:setPropertyName("camera")
Layer:setPropertyName("renderPass")
Layer:setPropertyName("lastPriority")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Layer:init(params)
    Layer:super(self)
    self._renderPass = self:newRenderPass()
    self._lastPriority = 0
    self.camera = Transform:new()
    self.camera:setPivot(Application.stageWidth / 2, Application.stageHeight / 2)

    if params then
        table.copy(params, self)
    end
end

---------------------------------------
-- MOAILayer2Dを生成します。
---------------------------------------
function Layer:newRenderPass()
    local layer = MOAILayer2D.new ()
    layer:setViewport(Application.window.viewport)
    layer:setSortMode(MOAILayer2D.SORT_PRIORITY_ASCENDING)
    layer:setPartition(MOAIPartition.new())
    return layer
end

---------------------------------------
-- 親オブジェクトを設定します。
-- 親オブジェクトはSceneである必要があります。
-- nilを設定した場合、親オブジェクトはクリアされます。
---------------------------------------
function Layer:setParent(parent)
    local myParent = self.parent
    if myParent == parent then
        return
    end
    -- 親から削除
    if myParent ~= nil then
        myParent:removeLayer(self)
    end

    -- 親に追加
    self.prop._parent = parent
    if parent then
        self.transformObj:setParent(parent.transformObj)
        parent:addLayer(self)
    end
end

---------------------------------------
-- 子オブジェクトを追加します。
---------------------------------------
function Layer:addChild(child)
    Group.addChild(self, child)
    child.layer = self
end

---------------------------------------
-- 描画オブジェクトを追加します。
---------------------------------------
function Layer:addProp(prop)
    self.invalidatedPriority = true
    self.renderPass:insertProp(prop)
end

---------------------------------------
-- 描画オブジェクトを削除します。
---------------------------------------
function Layer:removeProp(prop)
    self.renderPass:removeProp(prop)
end

---------------------------------------
-- レンダラーパスを返します。
---------------------------------------
function Layer:getRenderPass()
    return self._renderPass
end

---------------------------------------
-- MOAIPropを返します。
---------------------------------------
function Layer:getProp()
    return self.renderPass
end

---------------------------------------
-- カメラを設定します。
---------------------------------------
function Layer:setCamera(camera)
    self._camera = camera
    self.renderPass:setCamera(camera.transformObj)
end

---------------------------------------
-- カメラを返します。
---------------------------------------
function Layer:getCamera()
    return self._camera
end

---------------------------------------
-- フレーム毎の処理を行います。
-- invalidateDisplayList関数が呼ばれていた場合、
-- updateDisplayList関数を実行します。
---------------------------------------
function Layer:onEnterFrame(event)
    Group.onEnterFrame(self, event)
    if self.invalidatedPriority then
        Log.debug("Layer:onEnterFrame", "updatePriority()")
        self._lastPriority = 0
        self:updatePriority()
        self.invalidatedPriority = false
    end
end

---------------------------------------
-- 次のプライオリティを採番して返します。
---------------------------------------
function Layer:nextPriority()
    self._lastPriority = self._lastPriority + 1
    return self._lastPriority
end

---------------------------------------
-- 最後のプライオリティを返します。
---------------------------------------
function Layer:lastPriority()
    return self._lastPriority
end
