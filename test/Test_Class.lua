
require "hs/Class"

ClassA = Class()

function ClassA:init(a)
    print(a)
end

ClassB = ClassA()

function ClassB:init(a, b)
    self.__base:init(a)
    print(b)
end

ClassC = Class()

function ClassC:init(c)
    self.c = c
end

function ClassC:print()
    print(self.c)
end

local objA = ClassA:new("aaaaa")
local objB = ClassB:new("aa", "bb")
local objC = ClassC:new("cccc")
objC:print()

