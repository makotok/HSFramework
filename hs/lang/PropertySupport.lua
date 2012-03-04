--------------------------------------------------------------------------------
-- プロパティアクセスを可能にするためのクラスです。
--
-- 使用するクラスに、
-- __settersテーブルが存在した場合、そこからsetter関数を取得します。
-- __gettersテーブルが存在した場合、同テーブルからgetter関数を取得します。
--
--------------------------------------------------------------------------------
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

    -- プロパティの場合はプロパティ関数を使用
    if object:isProperty(key) then
        local setter = object:getSetter(key)
        if setter then
            setter(self, value)
        end
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

    -- プロパティの場合はプロパティ関数を使用
    if object:isProperty(key) then
        local getter = object:getGetter(key)
        if getter then
            return getter(self)
        else
            return nil
        end
    else
        return object[key]
    end
end

function PropertySupport:isProperty(key)
    if self.__setters[key] then
        return true
    end
    if self.__getters[key] then
        return true
    end
    return false
end

---------------------------------------
-- プロパティを定義します。
-- 指定したプロパティ名をプロパティと認識します。
---------------------------------------
function PropertySupport:setPropertyNames(...)
    for i, key in ipairs(...) do
        if type(key) == "string" then
            self:setPropertyName(key)
        elseif type(key) == "table" then
            self:setPropertyName(key.name, key.setter, key.getter)
        end
    end
end

---------------------------------------
-- プロパティを定義します。
-- プロパティ名とアクセスするsetter,getter名を設定します。
-- nilの場合は自動的にget,setが設定されます。
---------------------------------------
function PropertySupport:setPropertyName(key, setterName, getterName)
    local headName = string.upper(key:sub(1, 1))
    local upperName = key:len() > 1 and headName .. key:sub(2) or headName
    
    local setterName = setterName and setterName or "set" .. upperName
    local getterName = getterName and getterName or "get" .. upperName
    
    self.__setters[key] = setterName
    self.__getters[key] = getterName
end

---------------------------------------
-- 指定したプロパティ名のsetter関数を返します。
---------------------------------------
function PropertySupport:getSetter(key)
    local setterName = self.__setters[key]
    if setterName then
        return self[setterName]
    else
        return nil
    end
end

---------------------------------------
-- 指定したプロパティ名のgetter関数を返します。
---------------------------------------
function PropertySupport:getGetter(key)
    local getterName = self.__getters[key]
    if getterName then
        return self[getterName]
    else
        return nil
    end
end

