local ERROR_MSG = "test case error!"

function assertEquals(a, b)
    if a.equals and b.equals and not a.equals(b) then
        error(ERROR_MSG)
    elseif a ~= b then
        error(ERROR_MSG)
    end
end

function assertTrue(a)
    if a ~= true then
        error(ERROR_MSG)
    end
end

function assertFalse(a)
    if a ~= false then
        error(ERROR_MSG)
    end
end

function assertNotNull(a)
    if a == nil then
        error(ERROR_MSG)
    end
end

function assertNull(a)
    if a ~= nil then
        error(ERROR_MSG)
    end
end
