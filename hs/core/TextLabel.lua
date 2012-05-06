local table = require("hs/lang/table")
local FontManager = require("hs/core/FontManager")
local DisplayObject = require("hs/core/DisplayObject")

--------------------------------------------------------------------------------
-- 文字列を描画するラベルクラスです.
-- charcodesを指定せずとも、日本語の描画が行えます.
-- 
-- 効率的な文字列描画を行えるように、デフォルトのキャラコードのみで構成されたテキストを指定した場合、
-- キャッシュされたフォントを使用します.
-- 
-- 制約として、あまりに文字の種類が多い場合、自動生成したキャラコードが多くなり、
-- フォントテクスチャの生成に失敗する可能性があります.（実用にはそれほど問題ないかと）
-- 改善の余地はありますが、現時点では以下の方法により回避してください.
-- ・文字の種類を少なくする
-- ・fontSizeを小さくする
--
-- その他、以下の点で改善の余地があります.
-- ・DPIの設定に何を設定すればいいわからないのでsampleの値を設定しているが、後で検証が必要.
-- @class table
-- @name TextLabel
--------------------------------------------------------------------------------
local M = DisplayObject()

-- 定数
M.ALIGN_LEFT = MOAITextBox.LEFT_JUSTIFY
M.ALIGN_CENTER = MOAITextBox.CENTER_JUSTIFY
M.ALIGN_RIGHT = MOAITextBox.RIGHT_JUSTIFY

M.ALIGN_TYPES = {
    left = M.ALIGN_LEFT,
    center = M.ALIGN_CENTER,
    right = M.ALIGN_RIGHT
}

-- デフォルト値
-- 変更した場合、インスタンスの生成時にデフォルト値が使用されます.
M.defaultFontPath = "hs/resources/ipag.ttf"
M.defaultFontSize = 24

-- properties
M:setPropertyName("text")
M:setPropertyName("textAlign")
M:setPropertyName("fontSize")
M:setPropertyName("fontPath")

---------------------------------------
-- コンストラクタです.
---------------------------------------
function M:init(params)
    M:super(self, params)
end

function M:onInitial()
    -- 初期値
    self._fontSize = self.defaultFontSize
    self._fontPath = self.defaultFontPath
    self._textChanged = false
end

---------------------------------------
-- MOAIDeckを生成します.
-- 実際には生成しません.
---------------------------------------
function M:newDeck()
    return nil
end

---------------------------------------
-- MOAIPropを生成します.
-- インスタンスはMOAITextBoxになります
---------------------------------------
function M:newProp(deck)
    local prop = MOAITextBox.new()
    return prop
end

---------------------------------------
-- サイズを設定します.
---------------------------------------
function M:setSize(width, height)
    self._width = width
    self._height = height
    if self.prop then
        self.prop:setRect(0, 0, self.width, self.height)
        self:centerPivot()
    end
end

---------------------------------------
-- 設定値をMOAITextBoxに反映します.
---------------------------------------
function M:updateText()
    self._font = FontManager:getFont(self.fontPath)
    
    self.prop:setFont (self._font)
    self.prop:setTextSize(self.fontSize)
    self.prop:setString(self.text)
    
end

---------------------------------------
-- 表示文字列を設定します.
---------------------------------------
function M:setText(text)
    self._text = text
    self._textChanged = true
    self:invalidateDisplay()
end

---------------------------------------
-- 表示文字列を返します.
---------------------------------------
function M:getText()
    return self._text
end

---------------------------------------
-- 表示文字列を設定します.
---------------------------------------
function M:setTextAlign(align)
    self._textAlign = align
    if self.prop then
        self.prop:setAlignment(M.ALIGN_TYPES[align])
    end
end

---------------------------------------
-- 表示文字列を返します.
---------------------------------------
function M:getTextAlign()
    return self._text
end

---------------------------------------
-- フォントのサイズを設定します.
---------------------------------------
function M:setFontSize(size)
    self._fontSize = size
    self._textChanged = true
    self:invalidateDisplay()
end

---------------------------------------
-- フォントのサイズを返します.
---------------------------------------
function M:getFontSize()
    return self._fontSize
end

---------------------------------------
-- TrueTypeフォントのパスを設定します.
---------------------------------------
function M:setFontPath(fontPath)
    self._fontPath = fontPath
    self._textChanged = true
    self:invalidateDisplay()
end

---------------------------------------
-- TrueTypeフォントのパスを返します.
---------------------------------------
function M:getFontPath()
    return self._fontPath
end

---------------------------------------
-- フレーム毎の処理を行います.
---------------------------------------
function M:updateDisplay()
    DisplayObject.updateDisplay(self)
    if self._textChanged then
        self:updateText()
        self._textChanged = false
    end
end

return M