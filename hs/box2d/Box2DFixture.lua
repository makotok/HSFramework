local table = require("hs/lang/table")
local PropertySupport = require("hs/lang/PropertySupport")
local Box2DConfig = require("hs/box2d/Box2DConfig")

local M = PropertySupport()

M:setPropertyName("body")
M:setPropertyName("density")
M:setPropertyName("friction")
M:setPropertyName("restitution")
M:setPropertyName("sensor", "setSensor", "isSensor")

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(body, fixture)
    self._body = body
    self._fixture = fixture
    self._fixture.hsFixture = self
    
    table.copy(Box2DConfig.fixture, self)
end

---------------------------------------
-- Functions
---------------------------------------

function M:destroy()
    self._fixture:destroy()
end

function M:setCollisionHandler(handler, phaseMask, categoryMask)
    self._fixture:setCollisionHandler(
        function(phase, fixtureA, fixtureB, arbiter)
            handler(phase, fixtureA.hsFixture, fixtureB.hsFixture, arbiter)
        end,
        phaseMask,
        categoryMask
    )
end

function M:setFilter(categoryBits, maskBits, groupIndex)
    self._fixture:setFilter(categoryBits, maskBits, groupIndex)
end

---------------------------------------
-- Properties
---------------------------------------

function M:getBody()
    return self._body
end

---------------------------------------
-- density
---------------------------------------

function M:getDensity()
    return self._fixture._density
end

function M:setDensity(density)
    self._fixture._density = density
    self._fixture:setDensity(density)
end

---------------------------------------
-- friction
---------------------------------------

function M:getFriction()
    return self._fixture._friction
end

function M:setFriction(friction)
    self._fixture._friction = friction
    self._fixture:setFriction(friction)
end

---------------------------------------
-- restitution
---------------------------------------

function M:getRestitution()
    return self._fixture._restitution
end

function M:setRestitution(restitution)
    self._fixture._restitution = restitution
    self._fixture:setRestitution(restitution)
end

---------------------------------------
-- senser
---------------------------------------

function M:isSensor()
    return self._fixture._sensor
end

function M:setSensor(senser)
    self._fixture._sensor = senser
    self._fixture:setSensor(senser)
end

return M
