--------------------------------------------------------------------------------
-- クラスベースなオブジェクト指向を簡単に実現するためのクラスです。
-- クラスの基本的な機能を有します。
-- setmetatableによる継承ではなく、テーブルに展開する事でパフォーマンスが向上します。
-- simpleclassを参考にしています。
-- 
-- example)
-- ClassA = Class()
-- function ClassA:init(a)
--     print(a)
-- end
-- ClassB = ClassA()
-- function ClassB:init(a, b)
--     ClassB:super(self, a)
--     print(b)
-- end
-- 
-- local objA = ClassA:new("hello")
-- local objB = ClassB:new("hello", "world")
--
--------------------------------------------------------------------------------


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
-- 親クラスのコンストラクタを呼びます。
-- 
-- example)
-- function ClassA:init(a, b)
--     ClassA:super(self, a, b)
-- end
---------------------------------------
function Class:super(obj, ...)
    if self.__base then
        self.__base.init(obj, ...)
    end
end

---------------------------------------
-- インスタンスが指定したクラスのインスタンスか
-- どうか判定を行います。
---------------------------------------
function Class:instanceOf(class)
    if self == class then
        return true
    end
    if self.__index == class then
        return true
    end
    if self.__base then
        return self.__base:instanceOf(class)
    end
    return false
end

---------------------------------------
-- インスタンスかクラス判定して、
-- クラスの場合にtrueを返します。
---------------------------------------
function Class:isClass()
    return self.__index == nil
end

---------------------------------------
-- インスタンスかクラス判定して、
-- インスタンスの場合にtrueを返します。
---------------------------------------
function Class:isInstance()
    return self.__index ~= nil
end

---------------------------------------
-- インスタンスが同値かどうか判定します。
-- デフォルトでは、参照が同一の場合に同値と判定します。
---------------------------------------
function Class:equals(a)
    return self == a
end
