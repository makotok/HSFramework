--------------------------------------------------------------------------------
-- クラスベースなオブジェクト指向を簡単に実現するためのクラスです.<br>
-- クラスの基本的な機能を有します.<br>
-- setmetatableによる継承ではなく、テーブルに展開する事で<br>
-- 継承が多くなった場合でもパフォーマンスが劣化しません.<br>
-- @class table
-- @name Class
--------------------------------------------------------------------------------
Class = {}

setmetatable(Class, Class)

----------------------------------------
-- Functions
----------------------------------------

----------------------------------------
-- クラス定義関数です.
-- @return Classのコピー
----------------------------------------
function Class:__call()
    local class = {}
    setmetatable(class, self)
    table.deepCopy(self, class)
    class.__base = self
    return class
end

----------------------------------------
-- インスタンスの生成を行います.
-- @param ... コンストラクタに渡すパラメータ.
-- @return インスタンス
----------------------------------------
function Class:new(...)
   local obj = {}
   obj.__index = self
   setmetatable(obj, obj)
   if obj.init then
      obj:init(...)
   end
   return obj
end

----------------------------------------
-- コンストラクタです.<br>
-- Classを継承した子クラスは、この関数で初期化します.
-- @param ... パラメータ
----------------------------------------
function Class:init(...)
end

----------------------------------------
-- 親クラスのコンストラクタを呼びます.
-- @param obj 自身のオブジェクトを指定
-- @param ... コンストラクタに渡すパラメータ
----------------------------------------
function Class:super(obj, ...)
    if self.__base then
        self.__base.init(obj, ...)
    end
end

----------------------------------------
-- インスタンスが指定したクラスのインスタンスかどうか判定を行います.
-- @param class 判定したいClassを指定.
-- @return classを継承していた場合はtrue.
----------------------------------------
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

----------------------------------------
-- インスタンスかクラス判定して、クラスの場合にtrueを返します.
-- @return Classの場合はtrue
----------------------------------------
function Class:isClass()
    return self.__index == nil
end

----------------------------------------
-- インスタンスかクラス判定して、インスタンスの場合にtrueを返します.
-- @return Instanceの場合はtrue
----------------------------------------
function Class:isInstance()
    return self.__index ~= nil
end

----------------------------------------
-- インスタンスが同値かどうか判定します.<br>
-- デフォルトでは、参照が同一の場合に同値と判定します.
-- @param o インスタンス
----------------------------------------
function Class:equals(o)
    return self == o
end
