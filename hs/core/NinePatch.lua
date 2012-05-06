local table = require("hs/lang/table")
local DisplayObject = require("hs/core/DisplayObject")
local TextureManager = require("hs/core/TextureManager")

--------------------------------------------------------------------------------
-- 画像のサイズにあわせて、部分的に伸張するスプライトクラスです.
-- TODO:なんか使い勝手がいまいちかも
-- @class table
-- @name NinePatch
--------------------------------------------------------------------------------

local M = DisplayObject()

-- プロパティ定義
M:setPropertyName("texture")

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(texture, params)
    M:super(self)

    -- 初期化
    if texture then
        self:setTexture(texture)
    end
    if params then
        table.copy(params, self)
    end
    
end

---------------------------------------
-- MOAIDeckを生成します.
---------------------------------------
function M:newDeck()
    local deck = MOAIStretchPatch2D.new()
    
    deck:reserveRows(3)
    deck:setRow(1, 0.25, false)
    deck:setRow(2, 0.50, true )
    deck:setRow(3, 0.25, false)
    
    deck:reserveColumns( 3 )
    deck:setColumn(1, 0.25, false)
    deck:setColumn(2, 0.50, true )
    deck:setColumn(3, 0.25, false)
    
    deck:reserveUVRects(1)
    deck:setUVRect(1, 0, 0, 1, 1)
    return deck
end

---------------------------------------
-- テキスチャを設定します.
-- サイズも自動で設定されます.
---------------------------------------
function M:setTexture(texture)
    if type(texture) == "string" then
        texture = TextureManager:get(texture)
    end

    local width, height = texture:getSize()
    self.deck:setTexture(texture)
    self._texture = texture

    if self.width == 0 or self.height == 0 then
        self:setSize(width, height)
    end
end

function M:getTexture()
    return self._texture
end

---------------------------------------
-- 表示オブジェクトのサイズを設定します.
---------------------------------------
function M:setSize(width, height)
    DisplayObject.setSize(self, width, height)
    self.deck:setRect(0, 0, self.width, self.height)
end

return M