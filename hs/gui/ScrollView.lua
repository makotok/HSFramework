--------------------------------------------------------------------------------
-- 単一のテクスチャを描画する為のクラスです。
--
--------------------------------------------------------------------------------

ScrollView = View()


---------------------------------------
-- コンストラクタです。
---------------------------------------
function ScrollView:init(params)
    ScrollView:super(self, params)
end

---------------------------------------
-- 子オブジェクトを生成します。
---------------------------------------
function ScrollView:onTouchDown(event)
    View.onTouchDown(self, event)
    
    local worldX, worldY = event.x, event.y
    self._preWorldX = worldX
    self._preWorldY = worldY
end

---------------------------------------
-- 子オブジェクトを生成します。
---------------------------------------
function ScrollView:onTouchMove(event)
    View.onTouchMove(self, event)
    
    local worldX, worldY = event.x, event.y
    local moveX = self._preWorldX - worldX
    local moveY = self._preWorldY - worldY
    
    self.camera:setLocation(self.camera.x + moveX, self.camera.y + moveY)
    
    self._preWorldX = worldX
    self._preWorldY = worldY
    
    Log.debug("ScrollView:onTouchMove", moveX, moveY)
end
