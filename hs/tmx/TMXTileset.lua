--------------------------------------------------------------------------------
-- TMXMapのタイルセットクラスです。
--
--------------------------------------------------------------------------------

TMXTileset = Class()

---------------------------------------
-- コンストラクタです
---------------------------------------
function TMXTileset:init(tmxMap)
    TMXTileset:super(self)
    
    self.tmxMap = tmxMap
    self.name = ""
    self.firstgid = 0
    self.tilewidth = 0
    self.tileheight = 0
    self.spacing = 0
    self.margin = 0
    self.image = {source = "", width = 0, height = 0}
    self.tiles = {}
    self.properties = {}
    self.texture = nil
    
end

---------------------------------------
-- テクスチャをロードします。
-- ロード済の場合は再読み込みしません。
---------------------------------------
function TMXTileset:loadTexture()
    if self.texture then
        return
    end
    
    local directory = self.tmxMap.resourceDirectory
    local path = directory .. self.image.source

    self.texture = TextureCache:get(path)
    return self.texture
end

---------------------------------------
-- gidからタイルインデックスを返します。
---------------------------------------
function TMXTileset:getTileIndexByGid(gid)
    return gid - self.firstgid + 1
end
