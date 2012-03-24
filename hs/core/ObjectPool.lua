local Class = require("hs/lang/Class")

--------------------------------------------------------------------------------
-- オブジェクトプールの実装です.
-- テーブルの再利用等を目的とします.
-- @class table
-- @name ObjectPool
--------------------------------------------------------------------------------

local ObjectPool = Class()

---------------------------------------
-- インスタンスの初期化処理を行います.
---------------------------------------
function ObjectPool:init()
    self._pool = {}
end

---------------------------------------
-- オブジェクトの生成関数です.
-- 子クラスで継承して使用してください.
---------------------------------------
function ObjectPool:createObject(...)
    return nil
end

---------------------------------------
-- オブジェクトの初期化関数です.
-- 子クラスで継承して使用してください.
---------------------------------------
function ObjectPool:initObject(obj, ...)

end

---------------------------------------
-- オブジェクトを返します.
-- プールにない場合、factoryメソッドから、
-- オブジェクトを生成して返します.
-- 
-- 引数を指定した場合、factoryに渡されます.
-- また、プールに存在する場合はinitial関数に渡されます.
---------------------------------------
function ObjectPool:getObject(...)
    if #self._pool > 0 then
        local obj = self._pool[1]
        table.remove(self._pool, 1)
        self:initObject(obj, ...)
        return obj
    else
        local obj = self:createObject(...)
        obj._pooling = true
        return obj
    end
end

---------------------------------------
-- オブジェクトをプールに戻します.
---------------------------------------
function ObjectPool:releaseObject(object)
    if object._pooling then
        table.insert(self._pool, object)
    end
end

return ObjectPool