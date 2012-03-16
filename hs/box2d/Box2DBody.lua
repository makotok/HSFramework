Box2DBody = PropertySupport()

Box2DBody.BODY_TYPES = {
    dynamic = MOAIBox2DBody.DYNAMIC,
    static = MOAIBox2DBody.STATIC,
    kinematic = MOAIBox2DBody.KINEMATIC
}

Box2DBody:setPropertyName("x")
Box2DBody:setPropertyName("y")
Box2DBody:setPropertyName("angle")
Box2DBody:setPropertyName("angularVelocity")
Box2DBody:setPropertyName("angularDamping")
Box2DBody:setPropertyName("linearVelocityX")
Box2DBody:setPropertyName("linearVelocityY")
Box2DBody:setPropertyName("linearDamping")
Box2DBody:setPropertyName("awake", "setAwake", "isAwake")
Box2DBody:setPropertyName("active", "setActive", "isActive")
Box2DBody:setPropertyName("bullet", "setBullet", "isBullet")
Box2DBody:setPropertyName("fixedRotation", "setFixedRotation", "isFixedRotation")

function Box2DBody:init(world, body)
    self.world = world
    self.body = body
    self.body.hsBody = self
    self.fixtures = {}
    
    table.copy(Box2DConfig.body, self)
end

---------------------------------------
-- Functions
---------------------------------------

function Box2DBody:addCircle(x, y, radius)
    local fixture = Box2DFixture:new(body, self.body:addCircle(x, y, radius))
    table.insert(self.fixtures, fixture)
    return fixture
end

function Box2DBody:addEdges(verts)
    local fixture = Box2DFixture:new(body, self.body:addEdges(verts))
    table.insert(self.fixtures, fixture)
    return fixture
end

function Box2DBody:addPolygon(verts)
    local fixture = Box2DFixture:new(body, self.body:addPolygon(verts))
    table.insert(self.fixtures, fixture)
    return fixture
end

function Box2DBody:addRect(xMin, yMin, xMax, yMax)
    local fixture = Box2DFixture:new(body, self.body:addRect(xMin, yMin, xMax, yMax))
    table.insert(self.fixtures, fixture)
    return fixture
end

function Box2DBody:applyAngularImpulse(impulse)
    self.body:applyAngularImpulse(impulse)
end

function Box2DBody:applyForce(forceX, forceY, pointX, pointY)
    self.body:applyForce(forceX, forceY, pointX, pointY)
end

function Box2DBody:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
    self.body:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
end

function Box2DBody:applyTorque(torque)
    self.body:applyTorque(torque)
end

function Box2DBody:destroy()
    self.body:destroy()
end

---------------------------------------
-- Properties
---------------------------------------

---------------------------------------
-- angle
---------------------------------------

function Box2DBody:getAngle()
    return self.body:getAngle()
end

function Box2DBody:setAngle(angle)
    self:setTransform(self.x, self.y, angle)
end

---------------------------------------
-- angularVelocity
---------------------------------------

function Box2DBody:getAngularVelocity()
    return self.body:getAngularVelocity()
end

function Box2DBody:setAngularVelocity(omega)
    self.body:setAngularVelocity(omega)
end

---------------------------------------
-- angularDamping
---------------------------------------

function Box2DBody:getAngularDamping()
    return self.body._angularDamping
end

function Box2DBody:setAngularDamping(damping)
    self.body:setAngularDamping(damping)
    self.body._angularDamping = damping
end

---------------------------------------
-- inertia
---------------------------------------

function Box2DBody:getInertia()
    return self.body:getInertia()
end

---------------------------------------
-- linearVelocity
---------------------------------------

function Box2DBody:getLinearVelocity()
    return self.body:getLinearVelocity()
end

function Box2DBody:getLinearVelocityX()
    local x, y = self.body:getLinearVelocity()
    return x
end

function Box2DBody:getLinearVelocityY()
    local x, y = self.body:getLinearVelocity()
    return y
end

function Box2DBody:setLinearVelocity(velocityX, velocityY)
    self.body:setLinearVelocity(velocityX, velocityY)
end

function Box2DBody:setLinearVelocityX(velocityX)
    self:setLinearVelocity(velocityX, self.linearVelocityY)
end

function Box2DBody:setLinearVelocityY(velocityY)
    self:setLinearVelocity(self.linearVelocityX, velocityY)
end

---------------------------------------
-- linearDamping
---------------------------------------

function Box2DBody:getLinearDamping()
    return self.body._linearDamping
end

function Box2DBody:setLinearDamping(damping)
    self.body:setLinearDamping(damping)
    self.body._linearDamping = damping
end

---------------------------------------
-- mass
---------------------------------------

function Box2DBody:getMass()
    return self.body:getMass()
end

function Box2DBody:setMassData(mass, I, centerX, centerY)
    self.body:setMassData(mass, I, centerX, centerY)
end

function Box2DBody:setMass(mass)
    self.body:setMassData(mass)
end

function Box2DBody:resetMassData()
    self.body:resetMassData()
end

---------------------------------------
-- transform
---------------------------------------

function Box2DBody:setTransform(positionX, positionY, angle)
    self.body:setTransform(positionX, positionY, angle)
end

---------------------------------------
-- position
---------------------------------------

function Box2DBody:getPosition()
    return self.body:getPosition()
end

---------------------------------------
-- position x
---------------------------------------

function Box2DBody:getX()
    local x, y = self:getPosition()
    return x
end

function Box2DBody:setX(x)
    self:setTransform(x, self.y, self.angle)
end

---------------------------------------
-- position y
---------------------------------------

function Box2DBody:getY()
    local x, y = self:getPosition()
    return y
end

function Box2DBody:setY(y)
    self:setTransform(self.x, y, self.angle)
end

---------------------------------------
-- localCenter
---------------------------------------

function Box2DBody:getLocalCenter()
    return self.body:getLocalCenter()
end

---------------------------------------
-- worldCenter
---------------------------------------

function Box2DBody:getWorldCenter()
    return self.body:getWorldCenter()
end

---------------------------------------
-- active
---------------------------------------

function Box2DBody:isActive()
    return self.body:isActive()
end

function Box2DBody:setActive(active)
    self.body:setActive(active)
end


---------------------------------------
-- awake
---------------------------------------

function Box2DBody:isAwake()
    return self.body:isAwake()
end

function Box2DBody:setAwake(awake)
    self.body:setAwake(awake)
end

---------------------------------------
-- bullet
---------------------------------------

function Box2DBody:isBullet()
    return self.body:isBullet()
end

function Box2DBody:setBullet(bullet)
    self.body:setBullet(bullet)
end

---------------------------------------
-- fixedRotation
---------------------------------------

function Box2DBody:isFixedRotation()
    return self.body:isFixedRotation()
end

function Box2DBody:setFixedRotation(fixedRotation)
    self.body:setFixedRotation(fixedRotation)
end

