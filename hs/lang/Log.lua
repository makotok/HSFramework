Log = {}

-- 定数
Log.LEVEL_NONE = 0
Log.LEVEL_INFO = 1
Log.LEVEL_WARN = 2
Log.LEVEL_ERROR = 3
Log.LEVEL_DEBUG = 4

-- 変数
Log.level = Log.LEVEL_DEBUG

---------------------------------------
-- 通常ログを出力します。
---------------------------------------
function Log.info(...)
    if Log.level >= Log.LEVEL_INFO then
        print("[info]", unpack(...))
    end
end

---------------------------------------
-- 警告ログを出力します。
---------------------------------------
function Log.info(...)
    if Log.level >= Log.LEVEL_WARN then
        print("[info]", ...)
    end
end

---------------------------------------
-- エラーログを出力します。
---------------------------------------
function Log.error(...)
    if Log.level >= Log.LEVEL_ERROR then
        print("[error]", ...)
    end
end

---------------------------------------
-- デバッグログを出力します。
---------------------------------------
function Log.debug(...)
    if Log.level >= Log.LEVEL_DEBUG then
        print("[debug]", ...)
    end
end

