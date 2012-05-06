----------------------------------------------------------------
-- Box2Dの初期値の一覧です。
----------------------------------------------------------------

local M = {}

-- Box2DWorld
M.world = {
    gravityX = 0,
    gravityY = 10,
    unitsToMeters = 0.06
}

-- Box2DBody
M.body = {


}

-- Box2DFixture
M.fixture = {
    density = 1,
    --friction = 0,
    restitution = 0.3,
    --sensor = true
}

return M