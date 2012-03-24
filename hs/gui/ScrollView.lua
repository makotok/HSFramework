local table = require("hs/lang/table")
local math = require("hs/lang/math")
local View = require("hs/gui/View")
local Logger = require("hs/core/Logger")

--------------------------------------------------------------------------------
-- スクロールするViewクラスです。
-- TODO:とりあえず暫定で実装したので後で色々変更したい
--------------------------------------------------------------------------------
local ScrollView = View()

-- properties
ScrollView:setPropertyName("vScrollEnabled")
ScrollView:setPropertyName("hScrollEnabled")

---------------------------------------
-- コンストラクタです。
---------------------------------------
function ScrollView:init(params)
    ScrollView:super(self)
    
    self.vScrollEnabled = true
    self.hScrollEnabled = true
    self.friction = 0.1
    self._linearVelocityX = 0
    self._linearVelocityY = 0
    self._totalFrameMoveX = 0
    self._totalFrameMoveY = 0
    self._averageCount = 2
    self._frameMoveXQueue = {}
    self._frameMoveYQueue = {}
    self._isTouchDown = false
    self._scrolling = false

    if params then
        table.copy(params, self)
    end
end

---------------------------------------
-- フレームの処理です.
---------------------------------------
function ScrollView:onEnterFrame(event)
    View.onEnterFrame(self, event)
    
    -- 移動データを保存
    if self._isTouchDown then
        table.insert(self._frameMoveXQueue, 1, self._totalFrameMoveX)
        table.insert(self._frameMoveYQueue, 1, self._totalFrameMoveY)
        
        --Logger.info("totalFrameMove:", self._totalFrameMoveX, self._totalFrameMoveY)
        
        local queueXSize = #self._frameMoveXQueue
        local queueYSize = #self._frameMoveYQueue
        if queueXSize > 10 then
            table.remove(self._frameMoveXQueue)
        end
        if queueYSize > 10 then
            table.remove(self._frameMoveYQueue)
        end
    elseif self._scrolling then
        -- 移動量を求める
        local scrollX = self._linearVelocityX
        local scrollY = self._linearVelocityY
        scrollX = (-0.01 < scrollX and scrollX < 0.01) and 0 or scrollX
        scrollY = (-0.01 < scrollY and scrollY < 0.01) and 0 or scrollY
        
        -- 移動処理
        --Logger.info("scroll:", scrollX, scrollY)
        self.camera:setLocation(self.camera.x + scrollX, self.camera.y + scrollY)
        
        -- 次回のスクロール量を計算
        local rate = (1 - self.friction)
        self._linearVelocityX = scrollX * rate
        self._linearVelocityY = scrollY * rate
        
        -- 移動量がなくなった場合は停止
        if scrollX == 0 and scrollY == 0 then
            self._scrolling = false
        end
    end
    
    self._totalFrameMoveX = 0
    self._totalFrameMoveY = 0
end

---------------------------------------
-- タッチを開始した時のイベント処理です.
---------------------------------------
function ScrollView:onTouchDown(event)
    View.onTouchDown(self, event)
    self._isTouchDown = true
    self._scrolling = false
    
    local worldX, worldY = event.x, event.y
    self._preWorldX = worldX
    self._preWorldY = worldY
    
    self._frameMoveXQueue = {}
    self._frameMoveYQueue = {}
end

---------------------------------------
-- タッチを終了した時のイベント処理です.
---------------------------------------
function ScrollView:onTouchUp(event)
    View.onTouchUp(self, event)
    self._isTouchDown = false
    self._scrolling = true

    self._linearVelocityX = math.average(table.unpack(self._frameMoveXQueue))
    self._linearVelocityY = math.average(table.unpack(self._frameMoveYQueue))
    
    --Logger.info("linearVelocity:", self._linearVelocityX, self._linearVelocityY)
end

---------------------------------------
-- 子オブジェクトを生成します。
---------------------------------------
function ScrollView:onTouchMove(event)
    View.onTouchMove(self, event)
    
    -- touch downイベントが発生していないのにまれにくる場合がある
    if not self._isTouchDown then
        self:onTouchDown(event)
    end
    
    -- スクリーンの座標を取得
    -- TODO:ビューとスクリーンの比率の計算をしていない
    local worldX, worldY = event.x, event.y
    local preWorldX = self._preWorldX
    local preWorldY = self._preWorldY
    
    local moveX = preWorldX - worldX
    local moveY = preWorldY - worldY

    moveX = self.hScrollEnabled and moveX or 0
    moveY = self.vScrollEnabled and moveY or 0
    
    self.camera:setLocation(self.camera.x + moveX, self.camera.y + moveY)
    
    -- 移動位置を保存
    self._preWorldX = worldX
    self._preWorldY = worldY
    self._totalFrameMoveX = self._totalFrameMoveX + moveX
    self._totalFrameMoveY = self._totalFrameMoveY + moveY
end

function ScrollView:setVScrollEnabled(value)
    rawset(self, "vScrollEnabled", value)
end

function ScrollView:getVScrollEnabled()
    return rawget(self, "vScrollEnabled")
end

function ScrollView:setHScrollEnabled(value)
    rawset(self, "hScrollEnabled", value)
end

function ScrollView:getHScrollEnabled()
    return rawget(self, "hScrollEnabled")
end

return ScrollView