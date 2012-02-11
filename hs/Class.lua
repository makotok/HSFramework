

Class = {}
setmetatable(Class, Class)

---------------------------------------
-- クラスの定義を行います。
---------------------------------------
function Class:__call()
    local class = {}
    setmetatable(class, self)
    for i,v in pairs(self) do
        class[i] = v
    end
    class.__base = self
    return class
end

---------------------------------------
-- インスタンスの生成を行います。
---------------------------------------
function Class:new(...)
   local obj = {}
   obj.__index = self
   setmetatable(obj, obj)
   if obj.init then
      obj:init(...)
   end
   return obj
end

---------------------------------------
-- インスタンスの初期化処理を行います。
---------------------------------------
function Class:init(...)
end

---------------------------------------
-- インスタンスが指定したクラスのインスタンスか
-- どうか判定を行います。
---------------------------------------
function Class:instanceOf(class)
    if self.__index == class then
        return true
    end
    if self.__base then
        return self.__base:instanceOf(class)
    end
    return false
end

---------------------------------------
-- インスタンスが同値かどうか判定します。
-- デフォルトでは、参照が同一の場合に同値と判定します。
---------------------------------------
function Class:equals(a)
    return self == a
end
