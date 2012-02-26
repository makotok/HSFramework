--------------------------------------------------------------------------------
-- 単一のテクスチャを描画する為のクラスです。
--
--------------------------------------------------------------------------------

TMXMap = PropertySupport()

-- プロパティ定義
MapSprite:setPropertyName("layers")
MapSprite:setPropertyName("tilesets")
MapSprite:setPropertyName("properties")
MapSprite:setPropertyName("width")
MapSprite:setPropertyName("height")
MapSprite:setPropertyName("tileWidth")
MapSprite:setPropertyName("tileHeight")

---------------------------------------
-- コンストラクタです
---------------------------------------
function TMXMap:init()
    TMXMap:super(self)
    
    self._layers = {}
    self._tilesets = {}
    self._properties = {}
end

function TMXMap:drawLayers()
    for i, layer in ipairs(self.layers) do
        layer:drawLayer()
    end
end

function TMXMap:getLayers()
    return self._layers
end

function TMXMap:addLayers(layer)
    table.insert(self.layers, layer)
end

function TMXMap:getTilesets()
    return self._tilesets
end

function TMXMap:addTileset(tileset)
    table.insert(self.tilesets, tileset)
end

function TMXMap:getProperties()
    return self._properties
end

function TMXMap:getProperty(kye)
    return self._properties[key]
end

---------------------------------------
-- タイルのサイズを設定します。
---------------------------------------
function TMXMap:setSize(width, height)
    self._width = width
    self._height = height
end

---------------------------------------
-- タイルのサイズを設定します。
---------------------------------------
function TMXMap:setWidth(width)
    self:setSize(width, self.height)
end

---------------------------------------
-- タイルのサイズを返します。
---------------------------------------
function TMXMap:getWidth()
    return self._width
end

---------------------------------------
-- タイルのサイズを設定します。
---------------------------------------
function TMXMap:setHeight(height)
    self:setSize(self.width, height)
end

---------------------------------------
-- タイルのサイズを返します。
---------------------------------------
function TMXMap:getHeight()
    return self._height
end

---------------------------------------
-- タイルのサイズを設定します。
---------------------------------------
function TMXMap:setTileSize(width, height)
    self._tileWidth = width
    self._tileHeight = height
end

---------------------------------------
-- タイルのサイズを設定します。
---------------------------------------
function TMXMap:setTileWidth(width)
    self:setTileSize(width, self.tileHeight)
end

---------------------------------------
-- タイルのサイズを返します。
---------------------------------------
function TMXMap:getTileWidth()
    return self._tileWidth
end

---------------------------------------
-- タイルのサイズを設定します。
---------------------------------------
function TMXMap:setTileHeight(height)
    self:setTileSize(self.tileWidth, height)
end

---------------------------------------
-- タイルのサイズを返します。
---------------------------------------
function TMXMap:getTileHeight()
    return self._tileHeight
end
