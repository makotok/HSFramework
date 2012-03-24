----------------------------------------------------------------
-- Box2Dの初期値の一覧です。
----------------------------------------------------------------

local Box2DConfig = {}

-- Box2DWorld
Box2DConfig.world = {
    gravityX = 0,
    gravityY = 10,
    unitsToMeters = 0.06
}

-- Box2DBody
Box2DConfig.body = {


}

-- Box2DFixture
Box2DConfig.fixture = {
    density = 1,
    --friction = 0,
    restitution = 0.3,
    --sensor = true
}

return Box2DConfig