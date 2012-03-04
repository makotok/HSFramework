---------------------------------------
--- 配列から一致する値を検索して、見つかった位置を返します。
---------------------------------------
function table.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return 0
end

---------------------------------------
--- テーブルをコピーします。
---------------------------------------
function table.copy(src, dest)
    dest = dest and dest or {}
    for i, v in pairs(src) do
        dest[i] = v
    end
    return dest
end
