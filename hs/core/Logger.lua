local Logger = {}

-- 定数
Logger.LEVEL_NONE = 0
Logger.LEVEL_INFO = 1
Logger.LEVEL_WARN = 2
Logger.LEVEL_ERROR = 3
Logger.LEVEL_DEBUG = 4

-- 変数
Logger.level = Logger.LEVEL_ERROR

---------------------------------------
-- 通常ログを出力します.
---------------------------------------
function Logger.info(...)
    if Logger.level >= Logger.LEVEL_INFO then
        print("[info]", ...)
    end
end

---------------------------------------
-- 警告ログを出力します.
---------------------------------------
function Logger.warn(...)
    if Logger.level >= Logger.LEVEL_WARN then
        print("[warn]", ...)
    end
end

---------------------------------------
-- エラーログを出力します.
---------------------------------------
function Logger.error(...)
    if Logger.level >= Logger.LEVEL_ERROR then
        print("[error]", ...)
    end
end

---------------------------------------
-- デバッグログを出力します.
---------------------------------------
function Logger.debug(...)
    if Logger.level >= Logger.LEVEL_DEBUG then
        print("[debug]", ...)
    end
end

return Logger