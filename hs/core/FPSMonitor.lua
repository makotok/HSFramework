local PropertySupport = require("hs/lang/PropertySupport")
local logger = require("hs/core/Logger")

--------------------------------------------------------------------------------
-- FPSを観測する為のクラスです.
--
-- @class table
-- @name FPSMonitor
--------------------------------------------------------------------------------

local FPSMonitor = PropertySupport()

---------------------------------------
--- コンストラクタです
---------------------------------------
function FPSMonitor:init(sec, onFPS)
    self._sec = sec
    self._onFPS = onFPS
    self._running = false
    
    self.timer = MOAITimer.new()
    self.timer:setMode(MOAITimer.LOOP)
    self.timer:setSpeed(1 / self._sec)
    --TODO:Bug?
    --self.timer:setTime(self._sec)
    self.timer:setListener(MOAITimer.EVENT_TIMER_LOOP, function() self:onTimer() end)

end

function FPSMonitor:onTimer()
    logger.debug("FPSMonitor:onTimer", "FPS:" .. MOAISim.getPerformance())
    if self._onFPS then
        self._onFPS()
    end
end

function FPSMonitor:play()
    self.timer:start()
    return self
end

function FPSMonitor:stop()
    self.timer:stop()
end

return FPSMonitor