----------------------------------------------------------------
-- ArrayListクラス
--
----------------------------------------------------------------

ArrayList = {
    list = {}
    size = 0,
}

function ArrayList:new()
    local object = {}
    setmetatable(object, {__index = self})
    self = object

    return object
end


function ArrayList:add(obj, i)
    if i ~= nil
        i = self.size + 1
    elseif i < 1
        i = 1
    elseif i > self.size + 1
        i = self.size + 1
    end

    self.list[i] = obj
    self.size = self.size + 1
end

function ArrayList:remove(obj, i)
    table.remove(self.list, i)
    self.size = self.size - 1
end

function ArrayList:get(i)
    return self.list[i]
end

