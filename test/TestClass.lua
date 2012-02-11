TestClass = {}

------------------------------------------------------------
function TestClass:setUp()
    self.objA = TestClass.ClassA:new("aaa")
    self.objB = TestClass.ClassB:new("aaa", "bbb")
    self.objC = TestClass.ClassC:new("ccc")
end

function TestClass:test1_init()
    assertEquals(self.objA.a , "aaa")
    assertEquals(self.objB.a , "aaa")
    assertEquals(self.objB.b , "bbb")
    assertEquals(self.objC.c , "ccc")
    assertEquals(self.objC:getC() , "ccc")
end

function TestClass:test2_instanceOf()
    -- ClassA
    assert(self.objA:instanceOf(Class))
    assert(self.objA:instanceOf(TestClass.ClassA))
    assert(self.objA:instanceOf(TestClass.ClassB) == false)
    assert(self.objA:instanceOf(TestClass.ClassC) == false)
    -- ClassB
    assert(self.objB:instanceOf(Class))
    assert(self.objB:instanceOf(TestClass.ClassA))
    assert(self.objB:instanceOf(TestClass.ClassB))
    assert(self.objB:instanceOf(TestClass.ClassC) == false)
    -- ClassC
    assert(self.objC:instanceOf(Class))
    assert(self.objC:instanceOf(TestClass.ClassA) == false)
    assert(self.objC:instanceOf(TestClass.ClassB) == false)
    assert(self.objC:instanceOf(TestClass.ClassC))
    
end

function TestClass:test3_equals()
    local objAA = TestClass.ClassA:new("aaa")
    local objCC = TestClass.ClassC:new("ccc")
    
    assert(objAA:equals(self.objA))
    assert(self.objA:equals(objAA))
    
    assert(objCC:equals(self.objC) == false)
    assert(self.objC:equals(objCC) == false)
end

------------------------------------------------------------

TestClass.ClassA = Class()

function TestClass.ClassA:init(a)
    self.a = a
end
function TestClass.ClassA:equals(a)
    if self == a then
        return true
    end
    if a and a.a == self.a then
        return true
    end
    return false
end

TestClass.ClassB = TestClass.ClassA()

function TestClass.ClassB:init(a, b)
    TestClass.ClassB:super(self, a)
    self.b = b
end

TestClass.ClassC = Class()

function TestClass.ClassC:init(c)
    self.c = c
end

function TestClass.ClassC:getC()
    return self.c
end
