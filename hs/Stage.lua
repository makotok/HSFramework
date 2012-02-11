----------------------------------------------------------------
--画面の描画領域を表現するクラスです。
-- Stageは描画領域を管理します。
----------------------------------------------------------------

Stage = Group()

-- 定数
Stage.MODE_STRETCH = 1
Stage.MODE_EXPAND = 2
Stage.MODE_FIXED_RATIO = 3
Stage.MODE_EXACT = 4

-- プロパティ定義
DisplayObject:setPropertyDef("stageWidth", "setStageWidth", "getStageWidth")
DisplayObject:setPropertyDef("stageHeight", "setStageHeight", "getStageHeight")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Stage:init(width, height, mode)
    Group.init(self, width, height)

    -- オブジェクト定義
    self._stageWidth = 0
    self._stageHeight = 0
    self.stageMode = mode

    -- ステージの初期化
    self:initStageSize(width, height)

end

function Stage:initStageSize(width, height)

    -- デスクトップアプリケーションの場合、
    -- モードをMODE_EXACTに強制する
    if Runtime:isMobile() == false then
        self.stageMode = Stage.MODE_EXACT
    end

    -- モバイルの場合、指定されたモードにより、
    -- Viewportのサイズを変更する。
    local scaleWidth = width
    local scaleHeight = height
    local stageWidth = width
    local stageHeight = height
    local deviceWidth, deviceHeight = Runtime:getScreenSize()

    -- 伸張
    if self.stageMode == Window.MODE_STRETCH then
        scaleWidth = deviceWidth
        scaleHeight = deviceHeight

    -- 拡大
    elseif self.stageMode == Window.MODE_EXPAND then
         -- 比率を求める
         -- TODO:実装を考える
         --[[
        local scaleX = deviceWidth / width
        local scaleY = deviceHeight / height
        if scaleX < scaleY then scaleY = scaleX end
        if scaleX > scaleY then scaleX = scaleY end

        scaleWidth = deviceWidth
        scaleHeight = deviceHeight
        stageWidth = width * scaleX
        stageHeight = height * scaleY
        --]]

    -- 比率は同一
    elseif self.stageMode == Window.MODE_FIXED_RATIO then
        -- 比率を求める
        local scaleX = deviceWidth / width
        local scaleY = deviceHeight / height
        if scaleX < scaleY then scaleY = scaleX end
        if scaleX > scaleY then scaleX = scaleY end

        screenWidth = math.floor(width * scalaX)
        screenHeight = math.floor(height * scalaY)

    -- そのまま
    elseif self.stageMode == Window.MODE_EXACT then
    end

    -- サイズを設定
    self:setSize(scaleWidth, scaleHeight)
    self:setStageSize(stageWidth, stageHeight)
end

---------------------------------------
-- サイズを変更します。
-- 論理的なサイズとなります。
---------------------------------------
function Stage:setSize(width, height)
    DisplayObject.setSize(self, width, height)
    self.viewport:setScale(width, -height)
end

---------------------------------------
-- ステージサイズを変更します。
-- ステージサイズとは、実際に描画される範囲を表します。
---------------------------------------
function Stage:setStageSize(width, height)
    self.viewport:setSize(width, height)
    self._stageWidth = width
    self._stageHeight = height
end

---------------------------------------
-- ステージサイズを変更します。
---------------------------------------
function Stage:setStageWidth(width)
    self:setStageSize(width, self.stageHeight)
end

function Stage:getStageWidth()
    return self._stageWidth
end

---------------------------------------
-- ステージサイズを変更します。
---------------------------------------
function Stage:setStageHeight(height)
    self:setStageSize(self.stageWidth, height)
end

function Stage:getStageHeight()
    return self._stageHeight
end

