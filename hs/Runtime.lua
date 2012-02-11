Runtime = {}

---------------------------------------
--- 実行環境がモバイルかどうか返します。
---------------------------------------
function Runtime:isMobile()
    local bland = MOAIEnvironment.getOSBrand()
    return bland == MOAIEnvironment.OS_BRAND_ANDROID or bland == MOAIEnvironment.OS_BRAND_IOS
end

---------------------------------------
--- 実行環境の画面サイズを返します。
---------------------------------------
function Runtime:getScreenSize()
    return MOAIEnvironment.getScreenSize()
end
