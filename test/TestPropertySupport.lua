local PropertySupport = require("hs/lang/PropertySupport")

TestPropertySupport = {}

------------------------------------------------------------

function TestPropertySupport:setUp()
end

function TestPropertySupport:test1_getter()
    local obj = TestPropertySupport.ClassA:new(1, 2)
    assertEquals(obj.x , 1)
    assertEquals(obj._x , 1)
    assertEquals(obj.y , nil)
    assertEquals(obj._y , 2)
    assertEquals(obj.z , "z")
    assertEquals(obj.w , nil)
end

function TestPropertySupport:test2_setter()
    local obj = TestPropertySupport.ClassA:new()
    obj.x = 1
    obj.y = 2
    obj.z = 3
    obj.w = 4
    assertEquals(obj.x , 1)
    assertEquals(obj._x , 1)
    assertEquals(obj.y , nil)
    assertEquals(obj._y , 2)
    assertEquals(obj.z , "z")
    assertEquals(obj.w , 4)
end

------------------------------------------------------------

TestPropertySupport.ClassA = PropertySupport()
TestPropertySupport.ClassA:setPropertyName("x")
TestPropertySupport.ClassA:setPropertyName("y")
TestPropertySupport.ClassA:setPropertyName("z")

function TestPropertySupport.ClassA:init(x, y)
    TestPropertySupport.ClassA:super(self)
    self._x = x
    self._y = y
end

function TestPropertySupport.ClassA:setX(value)
    self._x = value
end

function TestPropertySupport.ClassA:getX()
    return self._x
end

function TestPropertySupport.ClassA:setY(y)
    self._y = y
end

function TestPropertySupport.ClassA:getZ()
    return "z"
end
