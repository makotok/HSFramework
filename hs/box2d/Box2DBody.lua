local table = require("hs/lang/table")
local PropertySupport = require("hs/lang/PropertySupport")
local Box2DConfig = require("hs/box2d/Box2DConfig")
local Box2DFixture = require("hs/box2d/Box2DFixture")

--------------------------------------------------------------------------------
-- MOAIBox2DBodyのラッパークラスです.<br>
-- 基本的にそのまま関数名をラッピングしています.<br>
-- いくつかの関数をプロパティアクセス可能にしています.
--
-- @class table
-- @name Box2DBody
--------------------------------------------------------------------------------
local Box2DBody = PropertySupport()

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

---------------------------------------
-- サークルを追加します.
---------------------------------------
function Box2DBody:addCircle(x, y, radius)
    local fixture = Box2DFixture:new(body, self.body:addCircle(x, y, radius))
    table.insert(self.fixtures, fixture)
    return fixture
end

---------------------------------------
-- エッジを追加します.
---------------------------------------
function Box2DBody:addEdges(verts)
    local fixture = Box2DFixture:new(body, self.body:addEdges(verts))
    table.insert(self.fixtures, fixture)
    return fixture
end

---------------------------------------
-- ポリゴンを追加します.
---------------------------------------
function Box2DBody:addPolygon(verts)
    local fixture = Box2DFixture:new(body, self.body:addPolygon(verts))
    table.insert(self.fixtures, fixture)
    return fixture
end

---------------------------------------
-- 四角形を追加します.
---------------------------------------
function Box2DBody:addRect(xMin, yMin, xMax, yMax)
    local fixture = Box2DFixture:new(body, self.body:addRect(xMin, yMin, xMax, yMax))
    table.insert(self.fixtures, fixture)
    return fixture
end

---------------------------------------
-- applyAngularImpulse.
---------------------------------------
function Box2DBody:applyAngularImpulse(impulse)
    self.body:applyAngularImpulse(impulse)
end

---------------------------------------
-- applyForce.
---------------------------------------
function Box2DBody:applyForce(forceX, forceY, pointX, pointY)
    self.body:applyForce(forceX, forceY, pointX, pointY)
end

---------------------------------------
-- applyLinearImpulse.
---------------------------------------
function Box2DBody:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
    self.body:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
end

---------------------------------------
-- applyTorque.
---------------------------------------
function Box2DBody:applyTorque(torque)
    self.body:applyTorque(torque)
end

---------------------------------------
-- destroy.
---------------------------------------
function Box2DBody:destroy()
    self.body:destroy()
end

---------------------------------------
-- Properties
---------------------------------------

---------------------------------------
-- angleを返します.
-- @return angle
---------------------------------------
function Box2DBody:getAngle()
    return self.body:getAngle()
end

---------------------------------------
-- angleを設定します.
-- @param angle angle
---------------------------------------
function Box2DBody:setAngle(angle)
    self:setTransform(self.x, self.y, angle)
end

---------------------------------------
-- angularVelocityを返します.
---------------------------------------
function Box2DBody:getAngularVelocity()
    return self.body:getAngularVelocity()
end

---------------------------------------
-- angularVelocityを設定します.
---------------------------------------
function Box2DBody:setAngularVelocity(omega)
    self.body:setAngularVelocity(omega)
end

---------------------------------------
-- angularDampingを返します.
---------------------------------------
function Box2DBody:getAngularDamping()
    return self.body._angularDamping
end

---------------------------------------
-- angularDampingを設定します.
---------------------------------------
function Box2DBody:setAngularDamping(damping)
    self.body:setAngularDamping(damping)
    self.body._angularDamping = damping
end

---------------------------------------
-- inertiaを返します.
---------------------------------------
function Box2DBody:getInertia()
    return self.body:getInertia()
end

---------------------------------------
-- linearVelocityを返します.
-- @return LinearVelocityX
-- @return LinearVelocityY
---------------------------------------
function Box2DBody:getLinearVelocity()
    return self.body:getLinearVelocity()
end

---------------------------------------
-- linearVelocityを設定します.
-- @param LinearVelocityX
-- @param LinearVelocityY
---------------------------------------
function Box2DBody:setLinearVelocity(velocityX, velocityY)
    self.body:setLinearVelocity(velocityX, velocityY)
end

---------------------------------------
-- LinearVelocityXを返します.
-- @return LinearVelocityX
---------------------------------------
function Box2DBody:getLinearVelocityX()
    local x, y = self.body:getLinearVelocity()
    return x
end

---------------------------------------
-- LinearVelocityXを設定します.
---------------------------------------
function Box2DBody:setLinearVelocityX(velocityX)
    self:setLinearVelocity(velocityX, self.linearVelocityY)
end

---------------------------------------
-- LinearVelocityYを返します.
-- @return LinearVelocityY
---------------------------------------
function Box2DBody:getLinearVelocityY()
    local x, y = self.body:getLinearVelocity()
    return y
end

---------------------------------------
-- LinearVelocityYを設定します.
---------------------------------------
function Box2DBody:setLinearVelocityY(velocityY)
    self:setLinearVelocity(self.linearVelocityX, velocityY)
end

---------------------------------------
-- linearDampingを返します.
-- @return linearDamping
---------------------------------------
function Box2DBody:getLinearDamping()
    return self.body._linearDamping
end

---------------------------------------
-- linearDampingを設定します.
---------------------------------------
function Box2DBody:setLinearDamping(damping)
    self.body:setLinearDamping(damping)
    self.body._linearDamping = damping
end

---------------------------------------
-- massを返します.
-- @return mass
---------------------------------------
function Box2DBody:getMass()
    return self.body:getMass()
end

---------------------------------------
-- massを設定します.
---------------------------------------
function Box2DBody:setMass(mass)
    self.body:setMassData(mass)
end

---------------------------------------
-- massDataを設定します.
---------------------------------------
function Box2DBody:setMassData(mass, I, centerX, centerY)
    self.body:setMassData(mass, I, centerX, centerY)
end

---------------------------------------
-- massDataをリセットします.
---------------------------------------
function Box2DBody:resetMassData()
    self.body:resetMassData()
end

---------------------------------------
-- 座標、回転量を設定します.
---------------------------------------
function Box2DBody:setTransform(positionX, positionY, angle)
    self.body:setTransform(positionX, positionY, angle)
end

---------------------------------------
-- positionX, positionYを返します.
-- @return positionX
-- @return positionY
---------------------------------------
function Box2DBody:getPosition()
    return self.body:getPosition()
end

---------------------------------------
-- x座標を返します.
-- @return x
---------------------------------------
function Box2DBody:getX()
    local x, y = self:getPosition()
    return x
end

---------------------------------------
-- x座標を設定します.
---------------------------------------
function Box2DBody:setX(x)
    self:setTransform(x, self.y, self.angle)
end

---------------------------------------
-- y座標を返します.
-- @return y
---------------------------------------
function Box2DBody:getY()
    local x, y = self:getPosition()
    return y
end

---------------------------------------
-- y座標を設定します.
---------------------------------------
function Box2DBody:setY(y)
    self:setTransform(self.x, y, self.angle)
end

---------------------------------------
-- localCenter座標を返します.
-- @return localCenterX
-- @return localCenterY
---------------------------------------
function Box2DBody:getLocalCenter()
    return self.body:getLocalCenter()
end

---------------------------------------
-- worldCenter
---------------------------------------

---------------------------------------
-- worldCenter座標を返します.
-- @return worldCenterX
-- @return worldCenterY
---------------------------------------
function Box2DBody:getWorldCenter()
    return self.body:getWorldCenter()
end

---------------------------------------
-- activeを返します.
-- @return active
---------------------------------------
function Box2DBody:isActive()
    return self.body:isActive()
end

---------------------------------------
-- activeを設定します.
---------------------------------------
function Box2DBody:setActive(active)
    self.body:setActive(active)
end

---------------------------------------
-- awakeを返します.
-- @return awake
---------------------------------------
function Box2DBody:isAwake()
    return self.body:isAwake()
end

---------------------------------------
-- awakeを設定します.
---------------------------------------
function Box2DBody:setAwake(awake)
    self.body:setAwake(awake)
end

---------------------------------------
-- bulletを返します.
-- @return bullet
---------------------------------------
function Box2DBody:isBullet()
    return self.body:isBullet()
end

---------------------------------------
-- bulletを設定します.
---------------------------------------
function Box2DBody:setBullet(bullet)
    self.body:setBullet(bullet)
end

---------------------------------------
-- fixedRotationを返します.
-- @return fixedRotation
---------------------------------------
function Box2DBody:isFixedRotation()
    return self.body:isFixedRotation()
end

---------------------------------------
-- fixedRotationを設定します.
---------------------------------------
function Box2DBody:setFixedRotation(fixedRotation)
    self.body:setFixedRotation(fixedRotation)
end

return Box2DBody