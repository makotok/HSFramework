--------------------------------------------------------------------------------
-- 単一のテクスチャを描画する為のクラスです.
--
-- @class table
-- @name Sprite
--------------------------------------------------------------------------------
Sprite = DisplayObject()

-- プロパティ定義
Sprite:setPropertyName("texture")
Sprite:setPropertyName("flipX")
Sprite:setPropertyName("flipY")

---------------------------------------
-- コンストラクタです.
-- @name Sprite:new
-- @param texture テクスチャ、もしくは、パス
-- @param params 設定プロパティテーブル
---------------------------------------
function Sprite:init(texture, params)
    Sprite:super(self)
    
    self._initialized = false
    self._flipX = false
    self._flipY = false

    -- 初期化
    if texture then
        self:setTexture(texture)
    end
    if params then
        table.copy(params, self)
    end
    
    -- UVマッピングを更新
    self:updateUVRect()
    
    self._initialized = true
end

---------------------------------------
-- MOAIDeckを生成します.
---------------------------------------
function Sprite:newDeck()
    local deck = MOAIGfxQuad2D.new()
    deck:setUVRect(0, 0, 1, 1)
    return deck
end

---------------------------------------
-- UVマッピングを更新します.
---------------------------------------
function Sprite:updateUVRect()
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
function Sprite:setTexture(texture)
    if type(texture) == "string" then
        texture = TextureCache:get(texture)
    end
    
    if not self._initialized and texture then
        local width, height = texture:getSize()
        self:setSize(width, height)
    end

    self.deck:setTexture(texture)
    self._texture = texture
end

---------------------------------------
-- テクスチャを返します.
---------------------------------------
function Sprite:getTexture()
    return self._texture
end

---------------------------------------
-- flipXを設定します.
---------------------------------------
function Sprite:setFlipX(value)
    self._flipX = value
    self:updateUVRect()
end

---------------------------------------
-- flipXを返します.
---------------------------------------
function Sprite:getFlipX()
    return self._flipX
end

---------------------------------------
-- flipYを設定します.
---------------------------------------
function Sprite:setFlipY(value)
    self._flipY = value
    self:updateUVRect()
end

---------------------------------------
-- flipYを返します.
---------------------------------------
function Sprite:getFlipY()
    return self._flipY
end

---------------------------------------
-- 表示オブジェクトのサイズを設定します.
---------------------------------------
function Sprite:setSize(width, height)
    DisplayObject.setSize(self, width, height)
    self.deck:setRect(0, 0, self.width, self.height)
end
