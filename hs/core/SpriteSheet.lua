local table = require("hs/lang/table")
local TextureCache = require("hs/core/TextureCache")
local DisplayObject = require("hs/core/DisplayObject")
local Event = require("hs/core/Event")

--------------------------------------------------------------------------------
-- テクスチャを任意のシートに分割して、シート毎に描画するクラスです.<br>
-- シートのアニメーション機能等を有します.<br>
-- @class table
-- @name SpriteSheet
--------------------------------------------------------------------------------
local SpriteSheet = DisplayObject()

-- プロパティ定義
SpriteSheet:setPropertyName("sheets")
SpriteSheet:setPropertyName("sheetsAnimations")
SpriteSheet:setPropertyName("sheetIndex")
SpriteSheet:setPropertyName("texture")

---------------------------------------
-- コンストラクタです
-- @name SpriteSheet:new
---------------------------------------
function SpriteSheet:init(params)
    SpriteSheet:super(self, params)
end

function SpriteSheet:onInitial()
    DisplayObject.onInitial(self)
    
    -- オブジェクト定義
    self._sheets = {}
    self._sheetIndex = 1
    self._sheetCurve = MOAIAnimCurve.new()
    self._sheetAnim = MOAIAnim:new()
    self._sheetsAnimations = {}
    
    -- イベントリスナの設定
    self._sheetAnim:setListener(MOAITimer.EVENT_TIMER_LOOP, 
        function(prop)
            local e = Event:new(Event.FRAME_LOOP)
            self:dispatchEvent(e)
        end
    )
    self._sheetAnim:setListener(MOAIAction.EVENT_STOP,
        function(prop)
            local e = Event:new(Event.FRAME_STOP)
            self:dispatchEvent(e)
        end
    )
end

---------------------------------------
-- 全てのシートデータを返します.
-- このテーブルを直接変更しても表示オブジェクトには反映されません.
-- @return sheets
---------------------------------------
function SpriteSheet:getSheets()
    return self._sheets
end

---------------------------------------
-- シートデータを設定します.<br>
-- {x = X座標, y = Y座標, width = 幅, height = 高さ}
-- の形式でテーブルを設定してください.<br>
-- 設定後、updateSheets()が呼ばれます.
-- @param value シートデータ
---------------------------------------
function SpriteSheet:setSheets(value)
    self._sheets = value
    self:updateSheets()
end

---------------------------------------
-- タイル形式のシートデータを設定します.
-- @param tileX X方向のタイル数
-- @param tileY Y方向のタイル数
---------------------------------------
function SpriteSheet:loadSheetsFromTile(tileX, tileY)
    self._sheets = {}
    for y = 1, tileY do
        for x = 1, tileX do
            self:addSheet((x - 1) * 32, (y - 1) * 32, 32, 32)
        end
    end
    self:updateSheets()
end

---------------------------------------
-- シートを追加します.<br>
-- updateSheets()は呼ばれませんので、任意のタイミングで呼んでください.
-- @param x x座標
-- @param x y座標
-- @param x 幅
-- @param x 高さ
---------------------------------------
function SpriteSheet:addSheet(x, y, width, height)
    local rect = {x = x, y = y, width = width, height = height}
    table.insert(self.sheets, rect)
end

---------------------------------------
-- シートを設定します.<br>
-- updateSheets()は呼ばれませんので、任意のタイミングで呼んでください.
---------------------------------------
function SpriteSheet:setSheet(index, x, y, width, height)
    local rect = {x = x, y = y, width = width, height = height}
    self.sheets[index] = rect
end

---------------------------------------
-- シートデータを表示オブジェクトに反映します.
---------------------------------------
function SpriteSheet:updateSheets()
    local texture = self.texture
    if not texture then
        return
    end

    local sheetCount = #self.sheets

    -- texture size
    local tw, th = texture:getSize()
    
    self.deck:reserve(sheetCount)
    for i, rect in ipairs(self.sheets) do
        local xMin, yMin = rect.x, rect.y
        local xMax = rect.x + rect.width
        local yMax = rect.y + rect.height
        self.deck:setRect(i, 0, 0, rect.width, rect.height)
        self.deck:setUVRect(i, xMin / tw, yMin / th, xMax / tw, yMax / th)
    end
end

---------------------------------------
-- MOAIDeckを生成します.
---------------------------------------
function SpriteSheet:newDeck()
    return MOAIGfxQuadDeck2D.new()
end

---------------------------------------
-- テキスチャを設定します.
-- サイズも自動で設定されます.
---------------------------------------
function SpriteSheet:setTexture(texture)
    if type(texture) == "string" then
        texture = TextureCache:get(texture)
    end

    local width, height = texture:getSize()
    self.deck:setTexture(texture)
    self._texture = texture
end

---------------------------------------
-- テキスチャを返します.
-- @return texture
---------------------------------------
function SpriteSheet:getTexture()
    return self._texture
end

---------------------------------------
-- 表示オブジェクトのサイズを設定します.
---------------------------------------
function SpriteSheet:setSize(width, height)
    self._width = width
    self._height = height
    self:centerPivot()
end

---------------------------------------
-- シート番号を設定します.
---------------------------------------
function SpriteSheet:setSheetIndex(value)
    self._sheetIndex = value
    self.prop:setIndex(value)
    
    local rect = self.sheets[value]
    self:setSize(rect.width, rect.height)
end

---------------------------------------
-- シート番号を返します.
---------------------------------------
function SpriteSheet:getSheetIndex()
    return self._sheetIndex
end

---------------------------------------
-- フレームアニメーションデータを返します.
---------------------------------------
function SpriteSheet:getSheetsAnimations()
    return self._sheetsAnimations
end

---------------------------------------
-- フレームアニメーションデータを設定します.
---------------------------------------
function SpriteSheet:setSheetsAnimations(animations)
    self._sheetsAnimations = animations
end

---------------------------------------
-- フレームアニメーションデータを返します.
---------------------------------------
function SpriteSheet:setSheetsAnimation(name)
    return self._sheetsAnimations[name]
end

---------------------------------------
-- フレームアニメーションデータを設定します.
---------------------------------------
function SpriteSheet:setSheetsAnimation(name, indexes, sec, mode)
    self._sheetsAnimations[name] = {indexes = indexes, sec = sec, mode = mode}
end

---------------------------------------
-- フレームアニメーションを開始します.
---------------------------------------
function SpriteSheet:play(name)
    local animData = self._sheetsAnimations[name]
    if not animData then
        return
    end

    local anim = self._sheetAnim
    if anim:isBusy() then
        anim:stop()
    end

    local curve = self._sheetCurve
    local indexes = animData.indexes
    curve:reserveKeys(#indexes)
    for i = 1, #indexes do
        curve:setKey ( i, animData.sec * (i - 1), indexes[i], MOAIEaseType.FLAT )
    end

    local mode = animData.mode or MOAITimer.LOOP
    anim:reserveLinks(1)
    anim:setMode(mode)
    anim:setLink(1, curve, self.prop, MOAIProp2D.ATTR_INDEX )
    anim:setCurve(curve)
    
    anim:start()
    return anim
end

---------------------------------------
-- フレームアニメーションを停止します.
---------------------------------------
function SpriteSheet:stop()
    self._sheetAnim:stop()
end

return SpriteSheet