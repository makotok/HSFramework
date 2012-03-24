--------------------------------------------------------------------------------
-- tableの機能拡張したモジュールです.
-- @class table
-- @name table
--------------------------------------------------------------------------------
local gtable = table
local table = {}
setmetatable(table, {__index = gtable})

---------------------------------------
-- 配列から一致する値を検索して、見つかった位置を返します.
-- @param array 配列
-- @param value 検索する値
-- @return 見つかった場合はindex,ない場合は0
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
-- テーブルをコピーします.
---------------------------------------
function table.copy(src, dest, includeFields, excludeFields)
    dest = dest and dest or {}
    for i, v in pairs(src) do
        dest[i] = v
    end
    return dest
end

---------------------------------------
-- テーブルをディープコピーします.
-- destを指定しない場合は新規テーブルを生成して返します.
-- @param src コピー元
-- @param dest コピー先(option)
-- @return コピー後テーブル
---------------------------------------
function table.deepCopy(src, dest)
    dest = dest and dest or {}
    for i, v in pairs(src) do
        if type(v) == "table" then
            dest[i] = {}
            table.deepCopy(v, dest[i])
        else
            dest[i] = v
        end
    end
    return dest
end

-- Lua5.1とLua5.2の互換性を保つ実装
if unpack then
    table.unpack = unpack
end

return table
