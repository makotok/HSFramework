local obj1 = {}
function obj1:aaa()
    print("aaa")
end

local obj2 = {}
setmetatable(obj2, {__index = obj1})

print("----------meta test----------")
for k, v in pairs(obj2) do
    print("key:" .. k)
end
print("----------meta test----------")
