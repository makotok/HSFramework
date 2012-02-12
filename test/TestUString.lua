TestUString = {}

------------------------------------------------------------
function TestUString:setUp()
end

function TestUString:test1_each()
    local str = UString:new("abcあいう")
    local exp = {"a", "b", "c", "あ", "い", "う"}
    local i = 1
    for s in str:each() do
        assertEquals(s, exp[i])
        i = i + 1
    end
    
end

function TestUString:test2_len()
    local str = UString:new("aあ")
    assertEquals(str:len(), 2)
end

function TestUString:test3_lenb()
    local str = UString:new("aあ")
    assertEquals(str:lenb(), 4)
end

function TestUString:test4_sub()
    local str = UString:new("abcあいう")
    assertEquals(str:sub(1), "abcあいう")
    assertEquals(str:sub(3, 4), "cあ")
    assertEquals(str:sub(4, 6), "あいう")
end

function TestUString:test5_subUString()
    local str = UString:new("abcあいう")
    assert(str:subUString(1):equals(UString:new("abcあいう")))
    assert(str:subUString(3, 3):equals(UString:new("c")))
    assert(str:subUString(4, 6):equals(UString:new("あいう")))
end
