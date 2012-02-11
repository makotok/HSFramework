--------------------------------------------------------------------------------
-- プロパティアクセスを可能にするためのクラスです。
--
-- 使用するクラスに、
-- __settersテーブルが存在した場合、そこからsetter関数を取得します。
-- __gettersテーブルが存在した場合、同テーブルからgetter関数を取得します。
--
--------------------------------------------------------------------------------
require "hs/Class"
require "hs/Log"

PropertySupport = Class()
PropertySupport.__setters = {}
PropertySupport.__getters = {}

---------------------------------------
-- インスタンスの生成を行います。
---------------------------------------
function PropertySupport:new(...)
   local proxy = {}
   local obj = {
       __proxy = proxy,
       __index = self
   }
   local meta = {
       __index = self.propertyAccess,
       __newindex = self.propertyChange,
       __object = obj
   }
   setmetatable(proxy, meta)
   setmetatable(obj, obj)
   if proxy.init then
      proxy:init(...)
   end
   return proxy
end

---------------------------------------
-- プロパティに値を設定した場合の処理です。
-- setter関数が存在する場合は、その関数を使用します。
---------------------------------------
function PropertySupport:propertyChange(key, value)
    local object = getmetatable(self).__object

    -- setter関数の参照
    local setter = object:getSetter(key)

    -- setter関数が存在する場合は、そちらを使用
    if setter then
        setter(self, value)
    else
        object[key] = value
    end
end

---------------------------------------
-- プロパティにアクセスした場合の処理です。
-- getter関数が存在する場合は、その関数を使用します。
---------------------------------------
function PropertySupport:propertyAccess(key)
    local object = getmetatable(self).__object

    -- getter関数の参照
    local getter = object:getGetter(key)

    -- getter関数が存在する場合は、そちらを使用
    if getter then
        return getter(self)
    else
        return object[key]
    end
end

---------------------------------------
-- プロパティを定義します。
-- プロパティ名とアクセスするsetter,getter名を設定します。
---------------------------------------
function PropertySupport:setPropertyDef(key, setterName, getterName)
    self.__setters[key] = setterName
    self.__getters[key] = getterName
end

---------------------------------------
-- プロパティを定義します。
-- プロパティ名とアクセスするsetter名を設定します。
---------------------------------------
function PropertySupport:setSetter(key, setterName)
    self.__setters[key] = setterName
end

function PropertySupport:getSetter(key)
    local setterName = self.__setters[key]
    if setterName then
        return self[setterName]
    else
        return nil
    end
end

---------------------------------------
-- プロパティを定義します。
-- プロパティ名とアクセスするgetter名を設定します。
---------------------------------------
function PropertySupport:setGetter(key, getterName)
    self.__getters[key] = getterName
end

function PropertySupport:getGetter(key)
    local getterName = self.__getters[key]
    if getterName then
        return self[getterName]
    else
        return nil
    end
end

