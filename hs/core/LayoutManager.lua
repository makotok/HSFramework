local table = require("hs/lang/table")
local PriorityQueue = require("hs/util/PriorityQueue")
local Application = require("hs/core/Application")
local Event = require("hs/core/Event")
local Logger = require("hs/core/Logger")

--------------------------------------------------------------------------------
-- DisplayObjectのレイアウトを管理するマネージャです.
--------------------------------------------------------------------------------

local LayoutManager = {}

--------------------------------------------------------------------------------
-- private
--------------------------------------------------------------------------------

-- 比較関数
local ascComparetor = function(a, b) 
    if a.nestLevel < b.nestLevel then
        return -1
    elseif a.nestLevel == b.nestLevel then
        return 0
    else
        return 1
    end
end

-- 比較関数
local descComparetor = function(a, b) 
    if a.nestLevel < b.nestLevel then
        return 1
    elseif a.nestLevel == b.nestLevel then
        return 0
    else
        return -1
    end
end

-- queue
local invalidatePropertiesQueue = PriorityQueue:new(ascComparetor)
local invalidateSizeQueue = PriorityQueue:new(descComparetor)
local invalidateDisplayQueue = PriorityQueue:new(descComparetor)

-- flag
local invalidatePropertiesFlag = false
local invalidateSizeFlag = false
local invalidateDisplayFlag = false

-- プロパティの検証実施
local function validateProperties()
    Logger.debug("LayoutManager:validateProperties()")
    local object = invalidatePropertiesQueue:poll()
    while object do
        object:validateProperties()
        object = invalidatePropertiesQueue:poll()
    end
end

-- サイズの検証実施
local function validateSize()
    Logger.debug("LayoutManager:validateSize()")
    local object = invalidateSizeQueue:poll()
    while object do
        object:validateSize()
        object = invalidateSizeQueue:poll()
    end
end

-- 表示の更新
local function validateDisplay()
    Logger.debug("LayoutManager:validateDisplay()", invalidateDisplayQueue:size())
    local object = invalidateDisplayQueue:poll()
    while object do
        object:validateDisplay()
        object = invalidateDisplayQueue:poll()
    end
end

-- フレーム処理
local function onEnterFrame(event)
    if invalidatePropertiesFlag then
        validateProperties()
        invalidatePropertiesFlag = false
    end
    if invalidateSizeFlag then
        validateSize()
        invalidateSizeFlag = false
    end
    if invalidateDisplayFlag then
        validateDisplay()
        invalidateDisplayFlag = false
    end
end

-- event handler
Application:addListener(Event.ENTER_FRAME, onEnterFrame)

--------------------------------------------------------------------------------
-- public functions
--------------------------------------------------------------------------------

---------------------------------------
--
---------------------------------------
function LayoutManager:invalidateProperties(object)
    invalidatePropertiesFlag = true
    invalidatePropertiesQueue:add(object)
end

---------------------------------------
--
---------------------------------------
function LayoutManager:invalidateSize(object)
    invalidateSizeFlag = true
    invalidateSizeQueue:add(object)
end

---------------------------------------
--
---------------------------------------
function LayoutManager:invalidateDisplay(object)
    invalidateDisplayFlag = true
    invalidateDisplayQueue:add(object)
end

return LayoutManager
