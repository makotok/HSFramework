--------------------------------------------------------------------------------
-- 単一のテクスチャを描画する為のクラスです。
--
--------------------------------------------------------------------------------

TMXTileset = PropertySupport()

-- プロパティ定義
TMXTileset:setPropertyName("texture")

---------------------------------------
-- コンストラクタです
---------------------------------------
function TMXTileset:init()
    TMXTileset:super(self)
    
    self.name = ""
    self.firstgid = 0
    self.tileWidth = 0
    self.tileHeight = 0
    self.image = {source = "", width = 0, height = 0}
    self.tiles = {}
    self.properties = {}
    self._texture = nil
    
end

---------------------------------------
-- テクスチャをロードします。
---------------------------------------
function TMXTileset:loadTexture()
    self._texture = TextureCache:get(self.imageSource)
end

---------------------------------------
-- テクスチャを返します。
---------------------------------------
function TMXTileset:getTexture()
    return self._texture
end
