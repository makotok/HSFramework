--------------------------------------------------------------------------------
-- オブジェクトプールの実装です。
-- テーブルの再利用等を目的とします。
--------------------------------------------------------------------------------

ObjectPool = Class()

---------------------------------------
-- インスタンスの初期化処理を行います。
---------------------------------------
function ObjectPool:init(factory, initial)
    self._factory = factory
    self._initial = initial
    self._pool = {}
end

---------------------------------------
-- オブジェクトを返します。
-- プールにない場合、factoryメソッドから、
-- オブジェクトを生成して返します。
-- 
-- 引数を指定した場合、factoryに渡されます。
-- また、プールに存在する場合はinitial関数に渡されます。
---------------------------------------
function ObjectPool:getObject(...)
    local obj = self._pool[1]
    
    if obj then
        table.remove(self._pool, 1)
        self._initial(obj, ...)
        return obj
    else
        return self._factory(...)
    end
end

---------------------------------------
-- オブジェクトをプールに戻します。
---------------------------------------
function ObjectPool:releaseObject(object)
    table.insert(self._pool, object)
end