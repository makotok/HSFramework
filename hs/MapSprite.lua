--------------------------------------------------------------------------------
-- 単一のテクスチャを描画する為のクラスです。
--
--------------------------------------------------------------------------------

MapSprite = DisplayObject()

-- プロパティ定義
MapSprite:setPropertyName("texture")
MapSprite:setPropertyName("grid")
MapSprite:setPropertyName("gridWidth")
MapSprite:setPropertyName("gridHeight")
MapSprite:setPropertyName("cellWidth")
MapSprite:setPropertyName("cellHeight")
MapSprite:setPropertyName("tileWidth")
MapSprite:setPropertyName("tileHeight")

---------------------------------------
-- コンストラクタです
---------------------------------------
function MapSprite:init(texture, params)
    MapSprite:super(self)
    
    -- 初期値
    self._grid = self:newGrid()
    self.prop:setGrid(self._grid)
    
    self._tileWidth = 1
    self._tileHeight = 1
    self._gridWidth = 1
    self._gridHeight = 1
    self._cellWidth = 0
    self._cellHeight = 0

    -- 初期化
    if texture then
        self:setTexture(texture)
    end
    if params then
        table.copy(params, self)
    end
    
end

---------------------------------------
-- MOAIDeckを生成します。
---------------------------------------
function MapSprite:newDeck()
    local deck = MOAITileDeck2D.new()
    return deck
end

---------------------------------------
-- MOAIGridを生成します。
---------------------------------------
function MapSprite:newGrid()
    local grid = MOAIGrid.new()
    grid:setRepeat(false)
    return grid
end

---------------------------------------
-- テキスチャを設定します。
-- サイズも自動で設定されます。
---------------------------------------
function MapSprite:setTexture(texture)
    if type(texture) == "string" then
        texture = Texture:get(texture)
    end

    self.deck:setTexture(texture)
    self._texture = texture
end

function MapSprite:getTexture()
    return self._texture
end

function MapSprite:getGrid()
    return self._grid
end

function MapSprite:setMapData(data)
    local row = #data
    local col = #data[1]
    for i, v in ipairs(data) do
        self:setRow(i, unpack(v))
    end
end

function MapSprite:setRow(row, ...)
    self.grid:setRow(row, ...)
end

function MapSprite:setTile(x, y, i)
    self.grid:setTile(x, y, i)
end

---------------------------------------
-- グリッドのサイズを更新します。
---------------------------------------
function MapSprite:refreshGridSize()
    self.grid:setSize(self.gridWidth, self.gridHeight, self.cellWidth, self.cellHeight, 0, 0, self.cellWidth, self.cellHeight)
    self:setSize(self.gridWidth * self.cellWidth, self.gridHeight * self.cellHeight)
end

---------------------------------------
-- サイズを設定します。
---------------------------------------
function MapSprite:setSize(width, height)
    self._width = width
    self._height = height
end


---------------------------------------
-- グリッドのサイズを設定します。
---------------------------------------
function MapSprite:setGridSize(width, height)
    self._gridWidth = width
    self._gridHeight = height
    self:refreshGridSize()
end

---------------------------------------
-- グリッドのサイズを設定します。
---------------------------------------
function MapSprite:getGridSize()
    return self._gridWidth, self._gridHeight
end

---------------------------------------
-- グリッドの列数を設定します。
---------------------------------------
function MapSprite:setGridWidth(width)
    self:setGridSize(width, self.gridHeight)
end

---------------------------------------
-- グリッドの列数を返します。
---------------------------------------
function MapSprite:getGridWidth()
    return self._gridWidth
end

---------------------------------------
-- グリッドの行数を設定します。
---------------------------------------
function MapSprite:setGridHeight(height)
    self:setGridSize(self.gridWidth, height)
end

---------------------------------------
-- グリッドの行数を返します。
---------------------------------------
function MapSprite:getGridHeight()
    return self._gridHeight
end

---------------------------------------
-- セルのサイズを設定します。
---------------------------------------
function MapSprite:setCellSize(width, height)
    self._cellWidth = width
    self._cellHeight = height
    self:refreshGridSize()
end

---------------------------------------
-- セルのサイズを設定します。
---------------------------------------
function MapSprite:getCellSize()
    return self._cellWidth, self._cellHeight
end

---------------------------------------
-- セルの幅を設定します。
---------------------------------------
function MapSprite:setCellWidth(width)
    self:setCellSize(width, self.cellHeight)
end

---------------------------------------
-- セルの幅を返します。
---------------------------------------
function MapSprite:getCellWidth()
    return self._cellWidth
end

---------------------------------------
-- セルの高さを設定します。
---------------------------------------
function MapSprite:setCellHeight(height)
    self:setCellSize(self.cellWidth, height)
end

---------------------------------------
-- セルの高さを返します。
---------------------------------------
function MapSprite:getCellHeight()
    return self._cellHeight
end

---------------------------------------
-- タイルのサイズを設定します。
---------------------------------------
function MapSprite:setTileSize(width, height, cellSizeUpdating)
    self._tileWidth = width
    self._tileHeight = height
    self.deck:setSize(width, height)
    if cellSizeUpdating == nil or cellSizeUpdating == true then
        local w, h = self.texture:getSize()
        self:setCellSize(w / width, h / height)    
    end
    self.deck:setRect(-0.5, 0.5, 0.5, -0.5)
end

---------------------------------------
-- タイルのサイズを返します。
---------------------------------------
function MapSprite:getTileSize()
    return self._tileWidth, self._tileHeight
end

---------------------------------------
-- タイルのサイズを設定します。
---------------------------------------
function MapSprite:setTileWidth(width)
    self:setTileSize(width, self.tileHeight)
end

---------------------------------------
-- タイルのサイズを返します。
---------------------------------------
function MapSprite:getTileWidth()
    return self._tileWidth
end

---------------------------------------
-- タイルのサイズを設定します。
---------------------------------------
function MapSprite:setTileHeight(height)
    self:setTileSize(self.tileWidth, height)
end

---------------------------------------
-- タイルのサイズを返します。
---------------------------------------
function MapSprite:getTileHeight()
    return self._tileHeight
end
