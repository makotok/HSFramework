-- import
local Class = require("hs/lang/Class")

--------------------------------------------------------------------------------
-- 多バイト(UTF8)に対応した文字列クラスです.<br>
-- UTF8として、1文字の長さは1と認識します.<br>
-- ソースコードがUTF8であれば問題なく使用できます.
-- @class table
-- @name UString
--------------------------------------------------------------------------------
local PriorityQueue = Class()

---------------------------------------
-- Functions
---------------------------------------

----------------------------------------
-- コンストラクタです.
-- @param 文字列
----------------------------------------
function PriorityQueue:init(comparetor)
    assert(comparetor, "comparetor is nil!")
    self.queue = {}
    self.comparetor = comparetor
end

----------------------------------------
-- オブジェクトを順序付けて追加します.
-- @param object オブジェクト
----------------------------------------
function PriorityQueue:add(object)
    local comparetor = assert(self.comparetor)
    local index = 0
    for i, v in ipairs(self.queue) do
        index = i
        if comparetor(object, v) > 0 then
            break
        end
    end
    index = index + 1
    table.insert(self.queue, index, item)
end

----------------------------------------
-- キューの先頭オブジェクト削除してから返します.<br>
-- キューに存在しない場合はnilを返します.
-- @return object
----------------------------------------
function PriorityQueue:poll()
    if self:size() > 0 then
        return table.remove(self.queue, 1)
    end
    return nil
end

----------------------------------------
-- 指定したインデックスのオブジェクトを返します.
-- @param i インデックス
-- @return object
----------------------------------------
function PriorityQueue:get(i)
    return self.queue[i]
end


----------------------------------------
-- 指定したオブジェクトが存在する場合削除します.
-- 存在しない場合は削除しません.
-- @param object オブジェクト
-- @return 削除した場合はそのオブジェクト
----------------------------------------
function PriorityQueue:remove(object)
    for i, v in ipairs(self.queue) do
        if object == v then
            return table.remove(self.queue, i)
        end
    end
    return nil
end

----------------------------------------
-- キューの内容をクリアします.
----------------------------------------
function PriorityQueue:clear()
    self.queue = {}
end

----------------------------------------
-- for文で使用できる for each関数です.<br>
----------------------------------------
function PriorityQueue:each()
    return ipairs(self.queue)
end

----------------------------------------
-- キューのサイズを返します.
-- @return キューのサイズ.
----------------------------------------
function PriorityQueue:size()
    return #self.queue
end

return PriorityQueue
