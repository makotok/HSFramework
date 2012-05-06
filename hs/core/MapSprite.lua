local table = require("hs/lang/table")
local DisplayObject = require("hs/core/DisplayObject")
local TextureManager = require("hs/core/TextureManager")

--------------------------------------------------------------------------------
-- 単一のテクスチャをグリッドで描画するクラスです.
-- TODO:関数の充実化
-- @class table
-- @name MapSprite
--------------------------------------------------------------------------------

local M = DisplayObject()

-- プロパティ定義
M:setPropertyName("texture")
M:setPropertyName("textureWidth")
M:setPropertyName("textureHeight")
M:setPropertyName("grid")
M:setPropertyName("gridWidth")
M:setPropertyName("gridHeight")
M:setPropertyName("cellWidth")
M:setPropertyName("cellHeight")
M:setPropertyName("tileWidth")
M:setPropertyName("tileHeight")
M:setPropertyName("repeat")

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(texture, gridWidth, gridHeight, tileWidth, tileHeight, cellWidth, cellHeight)
    M:super(self)
    
    -- 初期値
    self._grid = self:newGrid()
    self.prop:setGrid(self._grid)
    
    if texture then
        self:setTexture(texture)
    end
    
    self._gridWidth = gridWidth
    self._gridHeight = gridHeight
    self._tileWidth = tileWidth
    self._tileHeight = tileHeight
    self._repeat = false
    
    self:setGridSize(gridWidth, gridHeight)
    self:setTileSize(tileWidth, tileHeight)
    
    if cellWidth and cellHeight then
        self:setCellSize(cellWidth, cellHeight)
    else
        local w, h = self.texture:getSize()
        self:setCellSize(w / tileWidth, h / tileHeight)
    end
end

---------------------------------------
-- MOAIDeckを生成します.
---------------------------------------
function M:newDeck()
    local deck = MOAITileDeck2D.new()
    return deck
end

---------------------------------------
-- MOAIGridを生成します.
---------------------------------------
function M:newGrid()
    local grid = MOAIGrid.new()
    grid:setRepeat(false)
    return grid
end

---------------------------------------
-- テキスチャを設定します.
-- サイズも自動で設定されます.
---------------------------------------
function M:setTexture(texture)
    if type(texture) == "string" then
        texture = TextureManager:get(texture)
    end

    local w, h = texture:getSize()
    self.deck:setTexture(texture)
    self._texture = texture
    self._textureWidth = w
    self._textureHeight = h
end

---------------------------------------
-- textureを返します.
---------------------------------------
function M:getTexture()
    return self._texture
end

---------------------------------------
-- textureの幅を返します.
---------------------------------------
function M:getTextureWidth()
    return self._textureWidth
end

---------------------------------------
-- textureの高さを返します.
---------------------------------------
function M:getTextureHeight()
    return self._textureHeight
end

---------------------------------------
-- MOAIGridの幅を返します.
---------------------------------------
function M:getGrid()
    return self._grid
end

---------------------------------------
-- 二次元配列のマップデータを設定します.
-- マップデータは、行の配列です.
---------------------------------------
function M:setMapData(data)
    local row = #data
    local col = #data[1]
    for i, v in ipairs(data) do
        self:setRowData(i, unpack(v))
    end
end

---------------------------------------
-- 指定した行のデータを設定します.
---------------------------------------
function M:setRowData(row, ...)
    self.grid:setRow(row, ...)
end

---------------------------------------
-- グリッドのタイルを指定します.
---------------------------------------
function M:setTile(x, y, i)
    self.grid:setTile(x, y, i)
end

---------------------------------------
-- グリッドのサイズを更新します.
---------------------------------------
function M:updateGridSize()
    if not (self.gridWidth and self.gridHeight and self.cellWidth and self.cellHeight) then
        return
    end

    self.grid:setSize(self.gridWidth, self.gridHeight, self.cellWidth, self.cellHeight, 0, 0, self.cellWidth, self.cellHeight)
    self:setSize(self.gridWidth * self.cellWidth, self.gridHeight * self.cellHeight)
end

---------------------------------------
-- サイズを設定します.
---------------------------------------
function M:setSize(width, height)
    self._width = width
    self._height = height
end


---------------------------------------
-- グリッドのサイズを設定します.
---------------------------------------
function M:setGridSize(width, height)
    self._gridWidth = width
    self._gridHeight = height
    self:updateGridSize()
end

---------------------------------------
-- グリッドの列数を設定します.
---------------------------------------
function M:setGridWidth(width)
    self:setGridSize(width, self.gridHeight)
end

---------------------------------------
-- グリッドの列数を返します.
---------------------------------------
function M:getGridWidth()
    return self._gridWidth
end

---------------------------------------
-- グリッドの行数を設定します.
---------------------------------------
function M:setGridHeight(height)
    self:setGridSize(self.gridWidth, height)
end

---------------------------------------
-- グリッドの行数を返します.
---------------------------------------
function M:getGridHeight()
    return self._gridHeight
end

---------------------------------------
-- セルのサイズを設定します.
---------------------------------------
function M:setCellSize(width, height)
    self._cellWidth = width
    self._cellHeight = height
    self:updateGridSize()
end

---------------------------------------
-- セルの幅を設定します.
---------------------------------------
function M:setCellWidth(width)
    self:setCellSize(width, self.cellHeight)
end

---------------------------------------
-- セルの幅を返します.
---------------------------------------
function M:getCellWidth()
    return self._cellWidth
end

---------------------------------------
-- セルの高さを設定します.
---------------------------------------
function M:setCellHeight(height)
    self:setCellSize(self.cellWidth, height)
end

---------------------------------------
-- セルの高さを返します.
---------------------------------------
function M:getCellHeight()
    return self._cellHeight
end

---------------------------------------
-- タイルの行列数を設定します.
---------------------------------------
function M:setTileSize(width, height)
    self._tileWidth = width
    self._tileHeight = height
    
    local w, h = self.texture:getSize()
    self:setCellSize(w / width, h / height)

    self.deck:setSize(width, height)
    self.deck:setRect(-0.5, 0.5, 0.5, -0.5)
end

---------------------------------------
-- タイルの列数を設定します.
---------------------------------------
function M:setTileWidth(width)
    self:setTileSize(width, self.tileHeight)
end

---------------------------------------
-- タイルの列数を返します.
---------------------------------------
function M:getTileWidth()
    return self._tileWidth
end

---------------------------------------
-- タイルの行数を設定します.
---------------------------------------
function M:setTileHeight(height)
    self:setTileSize(self.tileWidth, height)
end

---------------------------------------
-- タイルの行数を返します.
---------------------------------------
function M:getTileHeight()
    return self._tileHeight
end

---------------------------------------
-- リピート描画するか設定します.
---------------------------------------
function M:setRepeat(value)
    self.grid:setRepeat(value)
    self._repeat = value
end

---------------------------------------
-- タイルの行数を返します.
---------------------------------------
function M:getRepeat()
    return self._repeat
end

return M