--------------------------------------------------------------------------------
-- 多バイト(UTF8)に対応した文字列クラスです.
-- @author Makoto
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 多バイト(UTF8)に対応した文字列クラスです.<br>
-- UTF8として、1文字の長さは1と認識します.<br>
-- ソースコードがUTF8であれば問題なく使用できます.
-- @class table
-- @name UString
--------------------------------------------------------------------------------
UString = Class()

---------------------------------------
-- Functions
---------------------------------------

----------------------------------------
-- コンストラクタです.
-- @param 文字列
----------------------------------------
function UString:init(utf8)
    self:setString(utf8)
end

----------------------------------------
-- len演算子です.<br>
-- TODO:上手く機能していないかも.
----------------------------------------
function UString:__len()
    return self.len()
end

----------------------------------------
-- tostring演算子.<br>
-- TODO:上手く機能していないかも.
----------------------------------------
function UString:__tostring()
    return self._utf8
end

----------------------------------------
-- for文で使用できる for each関数です.<br>
-- 以下のように使用します.<br>
-- <br>
-- for s in ustr:each() do <br>
--     print(s) <br>
-- end <br>
-- for s in UString.each(str) do <br>
--    print(s) <br>
-- end <br>
--
-- @param utf8 文字列.
-- @return for..in 関数.
----------------------------------------
function UString:each(utf8)
  local i=1
  local text = utf8 and utf8 or self._utf8
  return function()
    if i>#text then
      -- 終了
      return
    end
    local b=string.byte(text, i)
    if b==0 then
      -- eof
      return
    elseif b<128 then
      -- ascii
      local m=string.sub(text, i, i)
      i=i+1
      return m
    elseif b<192 then
      assert(false, 'invalid byte')
      return
    elseif b<224 then
      -- 2bytes
      local m=string.sub(text, i, i+1)
      i=i+2
      return m
    elseif b<240 then
      -- 3bytes(japanese multibyte)
      local m=string.sub(text, i, i+2)
      i=i+3
      return m
    elseif b<248 then
      -- 4bytes
      local m=string.sub(text, i, i+3)
      i=i+4
      return m
    elseif b<252 then
      -- 5bytes
      local m=string.sub(text, i, i+4)
      i=i+5
      return m
    elseif b<254 then
      -- 6bytes
      local m=string.sub(text, i, i+5)
      i=i+6
      return m
    else
      assert(false, 'unknown')
      return
    end
  end
end

----------------------------------------
-- UTF8の文字列の長さを返します.
-- @return 文字列の長さ.
----------------------------------------
function UString:len()
    return self._len
end

function UString._getLen(utf8)
    local i = 0
    for v in UString:each(utf8) do
        i = i + 1
    end
    return i    
end

----------------------------------------
-- 文字列のByte数を返します.
-- @return 文字のバイト数.
----------------------------------------
function UString:lenb()
    return string.len(self._utf8)
end

----------------------------------------
-- 文字列の特定範囲を抽出してstringを返します.
-- @param i 1からの開始位置
-- @param j 終了位置
-- @return 抽出した文字列
----------------------------------------
function UString:sub(i, j)
    if j == nil then
        j = self:len()
    end

    local count = 0
    local text = ""

    for v in self:each() do
        count = count + 1
        if count >= i then
            text = text .. v
        end
        if count >= j then
            break
        end
    end

    return text
end

----------------------------------------
-- 文字列の特定範囲を抽出してUStringを返します.
-- @param i 1からの開始位置
-- @param j 終了位置
-- @return 抽出した文字列のUStringインスタンス
----------------------------------------
function UString:subUString(i, j)
    return UString:new(self:sub(i, j))
end

----------------------------------------
-- 指定のstringに設定します.
-- @param utf8 string
-- @return self
----------------------------------------
function UString:setString(utf8)
    self._utf8 = utf8
    self._len = self._getLen(utf8)
    return self
end

----------------------------------------
-- stringを末尾に追加します.
-- @param utf8 string
-- @return self
----------------------------------------
function UString:append(utf8)
    self._utf8 = self._utf8 .. utf8
    self._len = self._len + self._getLen(utf8)
    return self
end

----------------------------------------
-- 指定の範囲の文字列を削除します.
-- @param i 1から始まる開始位置
-- @param j 終了位置、ない場合は最後(その文字は含めない)
-- @return self
----------------------------------------
function UString:delete(i, j)
    if i > #self + 1 then
        return self
    end
    j = j and j or (#self + 1)
    
    local text = self:sub(1, i)
    text = text .. self:sub(j)
    return self:setString(text)
end

----------------------------------------
-- 内部文字列を返します.
-- @return string
----------------------------------------
function UString:toString()
    return self._utf8
end

----------------------------------------
-- 大文字に変換した文字列をUStringで返します.
-- @return UString
----------------------------------------
function UString:toUpper()
    local text = ""
    for s in self:each() do
        text = text .. string.upper(s)
    end
    return UString:new(text)
end

----------------------------------------
-- 小文字に変換した文字列をUStringで返します.
-- @return UString
----------------------------------------
function UString:toLower()
    local text = ""
    for s in self:each() do
        text = text .. string.lower(s)
    end
    return UString:new(text)
end

----------------------------------------
-- 内部文字列が一致するか返します.
-- @return 文字列が一致する場合true
----------------------------------------
function UString:equals(ustr)
    return self._utf8 == ustr._ustr
end
