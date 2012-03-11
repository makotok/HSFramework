Box2DFixture = PropertySupport()

Box2DFixture:setPropertyName("body")
Box2DFixture:setPropertyName("density")
Box2DFixture:setPropertyName("friction")
Box2DFixture:setPropertyName("restitution")
Box2DFixture:setPropertyName("sensor", "setSensor", "isSensor")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Box2DFixture:init(body, fixture)
    self._body = body
    self._fixture = fixture
    self._fixture.hsFixture = self
    
    table.copy(Box2DConfig.fixture, self)
end

---------------------------------------
-- Functions
---------------------------------------

function Box2DFixture:destroy()
    self._fixture:destroy()
end

function Box2DFixture:setCollisionHandler(handler, phaseMask, categoryMask)
    self._fixture:setCollisionHandler(
        function(phase, fixtureA, fixtureB, arbiter)
            handler(phase, fixtureA.hsFixture, fixtureB.hsFixture, arbiter)
        end,
        phaseMask,
        categoryMask
    )
end

function Box2DFixture:setFilter(categoryBits, maskBits, groupIndex)
    self._fixture:setFilter(categoryBits, maskBits, groupIndex)
end

---------------------------------------
-- Properties
---------------------------------------

function Box2DFixture:getBody()
    return self._body
end

---------------------------------------
-- density
---------------------------------------

function Box2DFixture:getDensity()
    return self._fixture._density
end

function Box2DFixture:setDensity(density)
    self._fixture._density = density
    self._fixture:setDensity(density)
end

---------------------------------------
-- friction
---------------------------------------

function Box2DFixture:getFriction()
    return self._fixture._friction
end

function Box2DFixture:setFriction(friction)
    self._fixture._friction = friction
    self._fixture:setFriction(friction)
end

---------------------------------------
-- restitution
---------------------------------------

function Box2DFixture:getRestitution()
    return self._fixture._restitution
end

function Box2DFixture:setRestitution(restitution)
    self._fixture._restitution = restitution
    self._fixture:setRestitution(restitution)
end

---------------------------------------
-- senser
---------------------------------------

function Box2DFixture:isSensor()
    return self._fixture._sensor
end

function Box2DFixture:setSensor(senser)
    self._fixture._sensor = senser
    self._fixture:setSensor(senser)
end

