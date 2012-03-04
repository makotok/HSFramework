--------------------------------------------------------------------------------
-- TMXMapのObjectGroupです。
--
--------------------------------------------------------------------------------

TMXObjectGroup = Class()

---------------------------------------
-- コンストラクタです
---------------------------------------
function TMXObjectGroup:init(tmxMap)
    TMXObjectGroup:super()
    
    self.name = ""
    self.width = 0
    self.height = 0
    self.tmxMap = tmxMap
    self.objects = {}
    self.properties = {}
end

---------------------------------------
-- コンストラクタです
---------------------------------------
function TMXObjectGroup:createDisplayObjects()
end

---------------------------------------
-- オブジェクトを追加します。
---------------------------------------
function TMXObjectGroup:addObject(object)
    table.insert(self.objects, object)
end

---------------------------------------
-- プロパティを返します。
---------------------------------------
function TMXObjectGroup:getProperty(key)
    return self._properties[key]
end
