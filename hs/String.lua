----------------------------------------------------------------
-- 多バイトに対応した文字列クラスです
-- UTF8として、1文字の長さは1と認識します。
----------------------------------------------------------------


String = {}

function String.each(text)
  local i=1
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

function String.len(s)
    local i = 0
    for v in each_utf8(s) do
        i = i + 1
    end
    return i
end

function String.sub(s, i, j)
    if j == nil then
        j = String.len(s)
    end

    local count = 0
    local text = ""

    for v in String.each(s) do
        count = count + 1
        if count >= i then
            text
        end
        if count >= j then
            break
        end
    end

    return text
end



