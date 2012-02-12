--------------------------------------------------------------------------------
-- 表示オブジェクトを含める事ができるグルーピングクラスです
--
--------------------------------------------------------------------------------

Layer = Group()

-- プロパティ定義
Layer:setPropertyName("camera")
Layer:setPropertyName("renderPass")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Layer:init()
    Layer:super(self)
    self._renderPass = self:newRenderPass()
    self.camera = Transform:new()
end

---------------------------------------
-- MOAILayer2Dを生成します。
---------------------------------------
function Layer:newRenderPass()
    local layer = MOAILayer2D.new ()
    layer:setViewport(Application.window.viewport)
    --layer:setSortMode(MOAILayer2D.SORT_PRIORITY_ASCENDING)
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
    Log.debug("add prop!")
    self.renderPass:insertProp(prop)
end

---------------------------------------
-- 描画オブジェクトを削除します。
---------------------------------------
function Layer:removeProp(prop)
    Log.debug("remove prop!")
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