require "hs/HSFramework"
require "test/luaunit"

-- test cases
require "test/TestClass"
require "test/TestPropertySupport"
require "test/TestUString"
--require "test/TestEventDispatcher"

-- test all
LuaUnit:run()