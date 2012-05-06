local table = require("hs/lang/table")
local TextureManager = require("hs/core/TextureManager")
local DisplayObject = require("hs/core/DisplayObject")
local Event = require("hs/core/Event")

--------------------------------------------------------------------------------
-- 単一のテクスチャを描画する為のクラスです.
--
-- @class table
-- @name Sprite
--------------------------------------------------------------------------------
local M = DisplayObject()

-- プロパティ定義
M:setPropertyName("texture")
M:setPropertyName("flipX")
M:setPropertyName("flipY")

---------------------------------------
-- コンストラクタです.
-- @name Sprite:new
-- @param texture テクスチャ、もしくは、パス
-- @param params 設定プロパティテーブル
---------------------------------------
function M:init(texture, params)
    M:super(self)
    
    -- textureの設定
    if texture then
        self:setTexture(texture)
    end
    if params then
        table.copy(params, self)
    end
    -- UVマッピングを更新
    self:updateUVRect()
end

function M:onInitial()
    DisplayObject.onInitial(self)
    
    self._flipX = false
    self._flipY = false
end

---------------------------------------
-- MOAIDeckを生成します.
---------------------------------------
function M:newDeck()
    local deck = MOAIGfxQuad2D.new()
    deck:setUVRect(0, 0, 1, 1)
    return deck
end

---------------------------------------
-- UVマッピングを更新します.
---------------------------------------
function M:updateUVRect()
    local x1 = self.flipX and 1 or 0
    local y1 = self.flipY and 1 or 0
    local x2 = self.flipX and 0 or 1
    local y2 = self.flipY and 0 or 1
    self.deck:setUVRect(x1, y1, x2, y2)
end

---------------------------------------
-- テキスチャを設定します.
-- サイズも自動で設定されます.
---------------------------------------
function M:setTexture(texture)
    if type(texture) == "string" then
        texture = TextureManager:get(texture)
    end
    
    if not self._initialized and texture then
        local width, height = texture:getSize()
        self:setSize(width, height)
        self._initialized = true
    end

    self.deck:setTexture(texture)
    self._texture = texture
end

---------------------------------------
-- テクスチャを返します.
---------------------------------------
function M:getTexture()
    return self._texture
end

---------------------------------------
-- flipXを設定します.
---------------------------------------
function M:setFlipX(value)
    self._flipX = value
    self:updateUVRect()
end

---------------------------------------
-- flipXを返します.
---------------------------------------
function M:getFlipX()
    return self._flipX
end

---------------------------------------
-- flipYを設定します.
---------------------------------------
function M:setFlipY(value)
    self._flipY = value
    self:updateUVRect()
end

---------------------------------------
-- flipYを返します.
---------------------------------------
function M:getFlipY()
    return self._flipY
end

---------------------------------------
-- 表示オブジェクトのサイズを設定します.
---------------------------------------
function M:setSize(width, height)
    DisplayObject.setSize(self, width, height)
    self.deck:setRect(0, 0, self.width, self.height)
end

return M