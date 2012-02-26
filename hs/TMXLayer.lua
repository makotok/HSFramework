--------------------------------------------------------------------------------
-- 単一のテクスチャを描画する為のクラスです。
--
--------------------------------------------------------------------------------

TMXLayer = Group()

-- プロパティ定義
TMXLayer:setPropertyName("data")
TMXLayer:setPropertyName("layerWidth")
TMXLayer:setPropertyName("layerHeight")
TMXLayer:setPropertyName("tmxMap")
TMXLayer:setPropertyName("tilesets")
TMXLayer:setPropertyName("properties")

---------------------------------------
-- コンストラクタです
---------------------------------------
function TMXLayer:init(tmxMap, data, layerWidth, layerHeight)
    TMXLayer:super(self)
    
    self._tmxMap = tmxMap
    self._data = data
    self._layerWidth = layerWidth
    self._layerHeight = layerHeight
end

---------------------------------------
-- レイヤーのデータを返します。
---------------------------------------
function TMXLayer:getData()
    return self._mapData
end

---------------------------------------
-- レイヤーの描画を行います。
-- タイルセットのテクスチャが存在するのを対象とします。
---------------------------------------
function TMXLayer:drawLayer()
    local mapWidth = self.mapWidth
    local mapHeight = self.mapHeight
    for i, tileset in ipairs(self.tilesets) do
        local texture = tileset.texture
        if texture then
            local tw, th = texture:getSize()
            local mapSprite = MapSprite:new(texture, mapHeight, mapWidth, tw / tileset.tileWidth, th / tileset.tileHeight)
            self:addChild(mapSprite)
        end
    end
end

---------------------------------------
-- TMXMapを返します。
---------------------------------------
function TMXLayer:getTmxMap()
    return self._tmxMap
end

---------------------------------------
-- TMXTileset配列を返します。
---------------------------------------
function TMXLayer:getTilesets()
    return self.tmxMap.tilesets
end

---------------------------------------
-- プロパティを返します。
---------------------------------------
function TMXLayer:getProperties()
    return self._properties
end

---------------------------------------
-- プロパティを返します。
---------------------------------------
function TMXLayer:getProperty(key)
    return self._properties[key]
end

---------------------------------------
-- レイヤーの列数を返します。
---------------------------------------
function TMXLayer:getLayerWidth()
    return self._layerWidth
end

---------------------------------------
-- レイヤーの行数を返します。
---------------------------------------
function TMXLayer:getLayerHeight()
    return self._layerHeight
end

