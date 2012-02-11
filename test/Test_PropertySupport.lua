
require "hs/PropertySupport"

ClassA = PropertySupport()
ClassA:setPropertyDef("x", "setX", "getX")

function ClassA:init(value)
    PropertySupport.init(self)
    self._x = value
end

function ClassA:setX(value)
    print("setX:" .. value)
    self._x = value
end

function ClassA:getX()
    print("getX:" .. self._x)
    return self._x
end

local objA = ClassA:new(10)

print(objA.x)
objA.x = 20
print(objA.x)

