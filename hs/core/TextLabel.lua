--------------------------------------------------------------------------------
-- 文字列を描画するラベルクラスです。
-- charcodesを指定せずとも、日本語の描画が行えます。
-- 
-- 効率的な文字列描画を行えるように、デフォルトのキャラコードのみで構成されたテキストを指定した場合、
-- キャッシュされたフォントを使用します。
-- 
-- 制約として、あまりに文字の種類が多い場合、自動生成したキャラコードが多くなり、
-- フォントテクスチャの生成に失敗する可能性があります。（実用にはそれほど問題ないかと）
-- 改善の余地はありますが、現時点では以下の方法により回避してください。
-- ・文字の種類を少なくする
-- ・fontSizeを小さくする
--
-- その他、以下の点で改善の余地があります。
-- ・DPIの設定に何を設定すればいいわからないのでsampleの値を設定しているが、後で検証が必要。
--------------------------------------------------------------------------------

TextLabel = DisplayObject()

-- 定数
TextLabel.ALIGN_LEFT = MOAITextBox.LEFT_JUSTIFY
TextLabel.ALIGN_CENTER = MOAITextBox.CENTER_JUSTIFY
TextLabel.ALIGN_RIGHT = MOAITextBox.RIGHT_JUSTIFY

TextLabel.ALIGN_TYPES = {
    left = TextLabel.ALIGN_LEFT,
    center = TextLabel.ALIGN_CENTER,
    right = TextLabel.ALIGN_RIGHT
}

-- デフォルト値
-- 変更した場合、インスタンスの生成時にデフォルト値が使用されます。
TextLabel.defaultCharcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-_'
TextLabel.defaultFontTTF = "hs/resources/ipag.ttf"
TextLabel.defaultFontSize = 9
TextLabel.defaultFontDPI = 163

-- properties
TextLabel:setPropertyName("text")
TextLabel:setPropertyName("textAlign")
TextLabel:setPropertyName("charcodes")
TextLabel:setPropertyName("fontSize")
TextLabel:setPropertyName("fontTTF")
TextLabel:setPropertyName("fontDPI")

---------------------------------------
-- コンストラクタです。
---------------------------------------
function TextLabel:init(params)
    TextLabel:super(self)
    
    -- 初期値
    self._fontSize = self.defaultFontSize
    self._fontTTF = self.defaultFontTTF
    self._fontDPI = self.defaultFontDPI
    self._textChanged = false
    
    if params then
        table.copy(params, self)
    end
end

---------------------------------------
-- MOAIDeckを生成します。
-- 実際には生成しません。
---------------------------------------
function TextLabel:newDeck()
    return nil
end

---------------------------------------
-- MOAIPropを生成します。
-- インスタンスはMOAITextBoxになります
---------------------------------------
function TextLabel:newProp(deck)
    local prop = MOAITextBox.new()
    return prop
end

---------------------------------------
-- サイズを設定します。
---------------------------------------
function TextLabel:setSize(width, height)
    self._width = width
    self._height = height
    if self.prop then
        self.prop:setRect(0, 0, self.width, self.height)
        self:centerPivot()
    end
end

---------------------------------------
-- フォントのキャラコードを生成します。
-- マルチバイトを考慮して、ユニークとなる
-- キャラコードを生成します。
---------------------------------------
function TextLabel:makeCharcodes(text)
    if self:isDefaultCharcodesOnly(text) then
        return self.defaultCharcodes
    end
    
    charMap = {}
    charcodes = ""
    
    for c in UString:each(text) do
        charMap[c] = c
    end
    for k, v in pairs(charMap) do
        charcodes = charcodes .. v
    end
    
    return charcodes
end

---------------------------------------
-- デフォルトのキャラコードのみで構成された
-- 文字列のみかどうか判定します。
---------------------------------------
function TextLabel:isDefaultCharcodesOnly(text)
    local charMap = {}
    for s in UString:each(self.defaultCharcodes) do
        charMap[s] = s
    end
    
    for s in UString:each(text) do
        if charMap[s] == nil then
            return false
        end
    end
    return true
end

---------------------------------------
-- 設定値をMOAITextBoxに反映します。
---------------------------------------
function TextLabel:updateText()
    if not (self.text and self.charcodes) then
        return
    end

    self._font = FontCache:getFont(self.fontTTF, self.charcodes, self.fontSize, self.fontDPI)
    
    self.prop:setFont (self._font)
    self.prop:setTextSize(self._font:getScale())
    self.prop:setString(self.text)
    
end

---------------------------------------
-- 表示文字列を設定します。
---------------------------------------
function TextLabel:setText(text)
    self._charcodes = self:makeCharcodes(text)
    self._text = text
    self._textChanged = true
end

---------------------------------------
-- 表示文字列を返します。
---------------------------------------
function TextLabel:getText()
    return self._text
end

---------------------------------------
-- 表示文字列を設定します。
---------------------------------------
function TextLabel:setTextAlign(align)
    self._textAlign = align
    if self.prop then
        Log.debug("setTextAlign", align)
        self.prop:setAlignment(TextLabel.ALIGN_TYPES[align])
    end
end

---------------------------------------
-- 表示文字列を返します。
---------------------------------------
function TextLabel:getTextAlign()
    return self._text
end

---------------------------------------
-- フォントのキャラコードを返します。
---------------------------------------
function TextLabel:getCharcodes()
    return self._charcodes
end

---------------------------------------
-- フォントのサイズを設定します。
---------------------------------------
function TextLabel:setFontSize(size)
    self._fontSize = size
    self._textChanged = true
end

---------------------------------------
-- フォントのサイズを返します。
---------------------------------------
function TextLabel:getFontSize()
    return self._fontSize
end

---------------------------------------
-- TrueTypeフォントのパスを設定します。
---------------------------------------
function TextLabel:setFontTTF(ttfPath)
    self._fontTTF = ttfPath
    self._textChanged = true
end

---------------------------------------
-- TrueTypeフォントのパスを返します。
---------------------------------------
function TextLabel:getFontTTF()
    return self._fontTTF
end

---------------------------------------
-- フォントのDPIを設定します。
-- ライブラリ使用者側で意識しないでいいはずなので、
-- 明示的に設定する必要はありません。
---------------------------------------
function TextLabel:setFontDPI(dpi)
    self._fontDPI = dpi
    self._textChanged = true
end

---------------------------------------
-- フォントのDPIを返します。
---------------------------------------
function TextLabel:getFontDPI()
    return self._fontDPI
end

---------------------------------------
-- フレーム毎の処理を行います。
---------------------------------------
function TextLabel:onEnterFrame(event)
    if self._textChanged then
        self:updateText()
        self._textChanged = false
    end
    DisplayObject.onEnterFrame(self, event)
end