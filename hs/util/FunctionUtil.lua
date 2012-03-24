local FunctionUtil = {}

---------------------------------------
--- 関数が存在する場合、呼び出します。
---------------------------------------
function FunctionUtil.callExist(func, ...)
    if func then
        func(...)
    end
end

return FunctionUtil