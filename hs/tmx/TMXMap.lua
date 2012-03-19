--------------------------------------------------------------------------------
-- タイルマップ形式のデータを保持するTMXMapクラスです.<br>
-- タイルマップエディタについては、以下を参照してください.<br>
-- http://www.mapeditor.org/
-- @class table
-- @name TMXMap
--------------------------------------------------------------------------------

TMXMap = PropertySupport()

-- constraints
TMXMap.ATTRIBUTE_NAMES = {
    "version", "orientation", "width", "height", "tilewidth", "tileheight"
}

-- properties
TMXMap:setPropertyName("version")
TMXMap:setPropertyName("orientation")
TMXMap:setPropertyName("width")
TMXMap:setPropertyName("height")
TMXMap:setPropertyName("tilewidth")
TMXMap:setPropertyName("tileheight")
TMXMap:setPropertyName("layers")
TMXMap:setPropertyName("tilesets")
TMXMap:setPropertyName("objectGroups")
TMXMap:setPropertyName("properties")
TMXMap:setPropertyName("resourceDirectory")

---------------------------------------
-- コンストラクタです
---------------------------------------
function TMXMap:init()
    TMXMap:super(self)
    
    self._version = 0
    self._orientation = nil
    self._width = 0
    self._height = 0
    self._tilewidth = 0
    self._tileheight = 0
    self._resourceDirectory = ""
    self._layers = {}
    self._tilesets = {}
    self._objectGroups = {}
    self._properties = {}
end

function TMXMap:drawMap(parent)
    for i, layer in ipairs(self.layers) do
        layer:drawLayer(parent)
    end
end

---------------------------------------
-- TMXMapの情報を標準出力します.
---------------------------------------
function TMXMap:printDebugInfo()
    -- header
    print("<TMXMap>")
    
    -- attributes
    for i, attr in ipairs(self.ATTRIBUTE_NAMES) do
        local value = self[attr]
        value = value and value or ""
        print(attr .. " = " .. value)
    end
    print("</TMXMap>")

end

---------------------------------------
-- レイヤーリストを返します.
---------------------------------------
function TMXMap:getLayers()
    return self._layers
end

---------------------------------------
-- レイヤーを追加します.
---------------------------------------
function TMXMap:addLayer(layer)
    table.insert(self.layers, layer)
end

---------------------------------------
-- レイヤーを削除します.
---------------------------------------
function TMXMap:removeLayerAt(index)
    table.remove(self.layers, index)
end

---------------------------------------
-- タイルセットリストを返します.
---------------------------------------
function TMXMap:getTilesets()
    return self._tilesets
end

---------------------------------------
-- タイルセットを追加します.
---------------------------------------
function TMXMap:addTileset(tileset)
    table.insert(self.tilesets, tileset)
end

---------------------------------------
-- タイルセットを削除します.
---------------------------------------
function TMXMap:removeTilesetAt(index)
    table.remove(self.tilesets, index)
end

---------------------------------------
-- 指定されたGIDからタイルセットを検索して返します.
-- @param gid
-- @return TMXTileset
---------------------------------------
function TMXMap:findTilesetByGid(gid)
    local matchTileset = nil
    for i, tileset in ipairs(self.tilesets) do
        if gid >= tileset.firstgid then
            matchTileset = tileset
        end
    end
    return matchTileset
end

---------------------------------------
-- オブジェクトグループリストを返します.
---------------------------------------
function TMXMap:getObjectGroups()
    return self._objectGroups
end

---------------------------------------
-- タイルセットを追加します.
---------------------------------------
function TMXMap:addObjectGroup(objectGroup)
    table.insert(self.objectGroups, objectGroup)
end

---------------------------------------
-- タイルセットを削除します.
---------------------------------------
function TMXMap:removeObjectGroupAt(index)
    table.remove(self.objectGroups, index)
end

---------------------------------------
-- バージョンを設定します.
---------------------------------------
function TMXMap:setVersion(version)
    self._version = version
end

---------------------------------------
-- バージョンを返します.
---------------------------------------
function TMXMap:getVersion()
    return self._version
end

---------------------------------------
-- オリエンテーションを設定します.
---------------------------------------
function TMXMap:setOrientation(value)
    self._orientation = value
end

---------------------------------------
-- オリエンテーションを返します.
---------------------------------------
function TMXMap:getOrientation()
    return self._orientation
end

---------------------------------------
-- マップのサイズを設定します.
---------------------------------------
function TMXMap:setSize(width, height)
    self._width = width
    self._height = height
end

---------------------------------------
-- マップのサイズを設定します.
---------------------------------------
function TMXMap:setWidth(width)
    self:setSize(width, self.height)
end

---------------------------------------
-- マップのサイズを返します.
---------------------------------------
function TMXMap:getWidth()
    return self._width
end

---------------------------------------
-- マップのサイズを設定します.
---------------------------------------
function TMXMap:setHeight(height)
    self:setSize(self.width, height)
end

---------------------------------------
-- マップのサイズを返します.
---------------------------------------
function TMXMap:getHeight()
    return self._height
end

---------------------------------------
-- タイルのサイズを設定します.
---------------------------------------
function TMXMap:setTileSize(width, height)
    self._tilewidth = width
    self._tileheight = height
end

---------------------------------------
-- タイルのサイズを設定します.
---------------------------------------
function TMXMap:setTilewidth(width)
    self:setTileSize(width, self.tileheight)
end

---------------------------------------
-- タイルのサイズを返します.
---------------------------------------
function TMXMap:getTilewidth()
    return self._tilewidth
end

---------------------------------------
-- タイルのサイズを設定します.
---------------------------------------
function TMXMap:setTileheight(height)
    self:setTileSize(self.tilewidth, height)
end

---------------------------------------
-- タイルのサイズを返します.
---------------------------------------
function TMXMap:getTileheight()
    return self._tileheight
end

---------------------------------------
-- プロパティリストを返します.
---------------------------------------
function TMXMap:getProperties()
    return self._properties
end

---------------------------------------
-- 指定したキーのプロパティを返します.
---------------------------------------
function TMXMap:getProperty(key)
    return self._properties[key]
end

---------------------------------------
-- リソースディレクトリを設定します.
---------------------------------------
function TMXMap:setResourceDirectory(directory)
    self._resourceDirectory = directory
end

---------------------------------------
-- タイルのサイズを返します.
---------------------------------------
function TMXMap:getResourceDirectory()
    return self._resourceDirectory
end

