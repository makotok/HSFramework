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
local M = PropertySupport()

M.BODY_TYPES = {
    dynamic = MOAIBox2DBody.DYNAMIC,
    static = MOAIBox2DBody.STATIC,
    kinematic = MOAIBox2DBody.KINEMATIC
}

M:setPropertyName("x")
M:setPropertyName("y")
M:setPropertyName("angle")
M:setPropertyName("angularVelocity")
M:setPropertyName("angularDamping")
M:setPropertyName("linearVelocityX")
M:setPropertyName("linearVelocityY")
M:setPropertyName("linearDamping")
M:setPropertyName("awake", "setAwake", "isAwake")
M:setPropertyName("active", "setActive", "isActive")
M:setPropertyName("bullet", "setBullet", "isBullet")
M:setPropertyName("fixedRotation", "setFixedRotation", "isFixedRotation")

function M:init(world, body)
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
function M:addCircle(x, y, radius)
    local fixture = Box2DFixture:new(body, self.body:addCircle(x, y, radius))
    table.insert(self.fixtures, fixture)
    return fixture
end

---------------------------------------
-- エッジを追加します.
---------------------------------------
function M:addEdges(verts)
    local fixture = Box2DFixture:new(body, self.body:addEdges(verts))
    table.insert(self.fixtures, fixture)
    return fixture
end

---------------------------------------
-- ポリゴンを追加します.
---------------------------------------
function M:addPolygon(verts)
    local fixture = Box2DFixture:new(body, self.body:addPolygon(verts))
    table.insert(self.fixtures, fixture)
    return fixture
end

---------------------------------------
-- 四角形を追加します.
---------------------------------------
function M:addRect(xMin, yMin, xMax, yMax)
    local fixture = Box2DFixture:new(body, self.body:addRect(xMin, yMin, xMax, yMax))
    table.insert(self.fixtures, fixture)
    return fixture
end

---------------------------------------
-- applyAngularImpulse.
---------------------------------------
function M:applyAngularImpulse(impulse)
    self.body:applyAngularImpulse(impulse)
end

---------------------------------------
-- applyForce.
---------------------------------------
function M:applyForce(forceX, forceY, pointX, pointY)
    self.body:applyForce(forceX, forceY, pointX, pointY)
end

---------------------------------------
-- applyLinearImpulse.
---------------------------------------
function M:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
    self.body:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
end

---------------------------------------
-- applyTorque.
---------------------------------------
function M:applyTorque(torque)
    self.body:applyTorque(torque)
end

---------------------------------------
-- destroy.
---------------------------------------
function M:destroy()
    self.body:destroy()
end

---------------------------------------
-- Properties
---------------------------------------

---------------------------------------
-- angleを返します.
-- @return angle
---------------------------------------
function M:getAngle()
    return self.body:getAngle()
end

---------------------------------------
-- angleを設定します.
-- @param angle angle
---------------------------------------
function M:setAngle(angle)
    self:setTransform(self.x, self.y, angle)
end

---------------------------------------
-- angularVelocityを返します.
---------------------------------------
function M:getAngularVelocity()
    return self.body:getAngularVelocity()
end

---------------------------------------
-- angularVelocityを設定します.
---------------------------------------
function M:setAngularVelocity(omega)
    self.body:setAngularVelocity(omega)
end

---------------------------------------
-- angularDampingを返します.
---------------------------------------
function M:getAngularDamping()
    return self.body._angularDamping
end

---------------------------------------
-- angularDampingを設定します.
---------------------------------------
function M:setAngularDamping(damping)
    self.body:setAngularDamping(damping)
    self.body._angularDamping = damping
end

---------------------------------------
-- inertiaを返します.
---------------------------------------
function M:getInertia()
    return self.body:getInertia()
end

---------------------------------------
-- linearVelocityを返します.
-- @return LinearVelocityX
-- @return LinearVelocityY
---------------------------------------
function M:getLinearVelocity()
    return self.body:getLinearVelocity()
end

---------------------------------------
-- linearVelocityを設定します.
-- @param LinearVelocityX
-- @param LinearVelocityY
---------------------------------------
function M:setLinearVelocity(velocityX, velocityY)
    self.body:setLinearVelocity(velocityX, velocityY)
end

---------------------------------------
-- LinearVelocityXを返します.
-- @return LinearVelocityX
---------------------------------------
function M:getLinearVelocityX()
    local x, y = self.body:getLinearVelocity()
    return x
end

---------------------------------------
-- LinearVelocityXを設定します.
---------------------------------------
function M:setLinearVelocityX(velocityX)
    self:setLinearVelocity(velocityX, self.linearVelocityY)
end

---------------------------------------
-- LinearVelocityYを返します.
-- @return LinearVelocityY
---------------------------------------
function M:getLinearVelocityY()
    local x, y = self.body:getLinearVelocity()
    return y
end

---------------------------------------
-- LinearVelocityYを設定します.
---------------------------------------
function M:setLinearVelocityY(velocityY)
    self:setLinearVelocity(self.linearVelocityX, velocityY)
end

---------------------------------------
-- linearDampingを返します.
-- @return linearDamping
---------------------------------------
function M:getLinearDamping()
    return self.body._linearDamping
end

---------------------------------------
-- linearDampingを設定します.
---------------------------------------
function M:setLinearDamping(damping)
    self.body:setLinearDamping(damping)
    self.body._linearDamping = damping
end

---------------------------------------
-- massを返します.
-- @return mass
---------------------------------------
function M:getMass()
    return self.body:getMass()
end

---------------------------------------
-- massを設定します.
---------------------------------------
function M:setMass(mass)
    self.body:setMassData(mass)
end

---------------------------------------
-- massDataを設定します.
---------------------------------------
function M:setMassData(mass, I, centerX, centerY)
    self.body:setMassData(mass, I, centerX, centerY)
end

---------------------------------------
-- massDataをリセットします.
---------------------------------------
function M:resetMassData()
    self.body:resetMassData()
end

---------------------------------------
-- 座標、回転量を設定します.
---------------------------------------
function M:setTransform(positionX, positionY, angle)
    self.body:setTransform(positionX, positionY, angle)
end

---------------------------------------
-- positionX, positionYを返します.
-- @return positionX
-- @return positionY
---------------------------------------
function M:getPosition()
    return self.body:getPosition()
end

---------------------------------------
-- x座標を返します.
-- @return x
---------------------------------------
function M:getX()
    local x, y = self:getPosition()
    return x
end

---------------------------------------
-- x座標を設定します.
---------------------------------------
function M:setX(x)
    self:setTransform(x, self.y, self.angle)
end

---------------------------------------
-- y座標を返します.
-- @return y
---------------------------------------
function M:getY()
    local x, y = self:getPosition()
    return y
end

---------------------------------------
-- y座標を設定します.
---------------------------------------
function M:setY(y)
    self:setTransform(self.x, y, self.angle)
end

---------------------------------------
-- localCenter座標を返します.
-- @return localCenterX
-- @return localCenterY
---------------------------------------
function M:getLocalCenter()
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
function M:getWorldCenter()
    return self.body:getWorldCenter()
end

---------------------------------------
-- activeを返します.
-- @return active
---------------------------------------
function M:isActive()
    return self.body:isActive()
end

---------------------------------------
-- activeを設定します.
---------------------------------------
function M:setActive(active)
    self.body:setActive(active)
end

---------------------------------------
-- awakeを返します.
-- @return awake
---------------------------------------
function M:isAwake()
    return self.body:isAwake()
end

---------------------------------------
-- awakeを設定します.
---------------------------------------
function M:setAwake(awake)
    self.body:setAwake(awake)
end

---------------------------------------
-- bulletを返します.
-- @return bullet
---------------------------------------
function M:isBullet()
    return self.body:isBullet()
end

---------------------------------------
-- bulletを設定します.
---------------------------------------
function M:setBullet(bullet)
    self.body:setBullet(bullet)
end

---------------------------------------
-- fixedRotationを返します.
-- @return fixedRotation
---------------------------------------
function M:isFixedRotation()
    return self.body:isFixedRotation()
end

---------------------------------------
-- fixedRotationを設定します.
---------------------------------------
function M:setFixedRotation(fixedRotation)
    self.body:setFixedRotation(fixedRotation)
end

return M