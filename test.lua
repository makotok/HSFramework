require "hs/HSFramework"
require "test/luaunit"

-- test cases
require "test/TestClass"
require "test/TestPropertySupport"
require "test/TestUString"
require "test/TestTMXMapLoader"
--require "test/TestEventDispatcher"
require "test.ModuleA"

-- load classes
local globals = {}
for k, v in pairs(_G) do
    table.insert(globals, k)
end
table.sort(globals)
for i, v in pairs(globals) do
    print("global:" .. v)
end
-- load modules
local modules = {}
for k, v in pairs(package.loaded) do
    table.insert(modules, k)
end
table.sort(modules)
for i, v in pairs(modules) do
    print("module:" .. v)
end



-- test all
LuaUnit:run()