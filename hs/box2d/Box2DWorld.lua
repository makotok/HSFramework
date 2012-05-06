local table = require("hs/lang/table")
local PropertySupport = require("hs/lang/PropertySupport")
local Box2DConfig = require("hs/box2d/Box2DConfig")
local Box2DBody = require("hs/box2d/Box2DBody")
local Box2DFixture = require("hs/box2d/Box2DFixture")

----------------------------------------------------------------
-- MOAIBox2DWorldのWrapperクラスです。
-- プロパティアクセスを可能とします。
--
-- TODO:オーバーヘッドがどの程度か後で計測したい
----------------------------------------------------------------

local M = PropertySupport()

M:setPropertyName("layer")
M:setPropertyName("angularSleepTolerance")
M:setPropertyName("autoClearForces")
M:setPropertyName("linearSleepTolerance")
M:setPropertyName("timeToSleep")
M:setPropertyName("gravityX")
M:setPropertyName("gravityY")
M:setPropertyName("unitsToMeters")
M:setPropertyName("debugDraw")

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(params)
    self.world = MOAIBox2DWorld.new()
    self.displays = {}
    self.bodies = {}
    self.joints = {}
    
    -- 単純コピーは不可。順番が関係するらしい
    self.gravityX = Box2DConfig.world.gravityX
    self.gravityY = Box2DConfig.world.gravityY
    self.unitsToMeters = Box2DConfig.world.unitsToMeters
    
    table.copy(params, self)
end

---------------------------------------
-- Function
---------------------------------------

function M:start()
    self.world:start()
end

function M:addBodyFromDisplay(displayObject, params)
    local world = self.world
    
    -- displayObject
    local dx, dy = displayObject:getWorldLocation()
    local dw, dh = displayObject:getSize()
    local angle = displayObject.rotation
    
    -- bodyの作成
    local body = self:addBody(Box2DBody.BODY_TYPES[params.bodyType])
    
    -- fixtureの作成
    local fixture
    params.shapeType = params.shapeType and params.shapeType or "rectangle"
    if params.shapeType == "circle" then
        fixture = body:addCircle(0, 0, dw / 2)
    elseif tempFixture.shape == "rectangle" then
        fixture = body:addRect(0, 0, dw, dh)
    elseif tempFixture.shape == "polygon" then 
        fixture = body:addPolygon(params.polygon)
    end
    
    -- displayのリンク
    --displayObject.parent = body

    -- 
    table.insert(self.displays, displayObject)
    return body
end


function M:addBody(bodyType, params)
    local body = Box2DBody:new(world, self.world:addBody(bodyType))
    if params then
        table.copy(params, body)
    end
    return body
end

function M:addDistanceJoint(...)
    local joint = self.world:addDistanceJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function M:addFrictionJoint(...)
    local joint = self.world:addFrictionJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function M:addGearJoint(...)
    local joint = self.world:addGearJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function M:addMouseJoint(...)
    local joint = self.world:addMouseJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function M:addPrismaticJoint(...)
    local joint = self.world:addPrismaticJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function M:addPulleyJoint(...)
    local joint = self.world:addPulleyJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function M:addRevoluteJoint(...)
    local joint = self.world:addRevoluteJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function M:addRopeJoint(...)
    local joint = self.world:addRopeJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function M:addWeldJoint(...)
    local joint = self.world:addWeldJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function M:addWheelJoint(...)
    local joint = self.world:addWheelJoint(...)
    table.insert(self.joints, joint)
    return joint
end

---------------------------------------
-- Properties
---------------------------------------

---------------------------------------
-- layer
---------------------------------------

function M:getLayer()
    return self._layer
end

function M:setLayer(layer)
    self._layer = layer
    if self.debugDraw and layer then
        layer.renderPass:setBox2DWorld(self.world)
    end
end

---------------------------------------
-- angularSleepTolerance
---------------------------------------

function M:getAngularSleepTolerance()
    return self.world:getAngularSleepTolerance()
end

function M:setAngularSleepTolerance(value)
    self.world:setAngularSleepTolerance(value)
end

---------------------------------------
-- autoClearForces
---------------------------------------

function M:getAutoClearForces()
    return self.world:getAutoClearForces()
end

function M:setAutoClearForces(value)
    self.world:setAutoClearForces(value)
end

---------------------------------------
-- linearSleepTolerance
---------------------------------------

function M:getLinearSleepTolerance()
    return self.world:getLinearSleepTolerance()
end

function M:setLinearSleepTolerance(value)
    self.world:setLinearSleepTolerance(value)
end

---------------------------------------
-- timeToSleep
---------------------------------------

function M:getTimeToSleep()
    return self.world:getTimeToSleep()
end

function M:setTimeToSleep(value)
    self.world:setTimeToSleep(value)
end

---------------------------------------
-- gravity
---------------------------------------

function M:getGravity()
    return self.world:getGravity()
end

function M:getGravityX()
    local x, y = self.world:getGravity()
    return x
end

function M:getGravityY()
    local x, y = self.world:getGravity()
    return y
end

function M:setGravity(x, y)
    self.world:setGravity(x, y)
end

function M:setGravityX(x)
    self:setGravity(x, self.gravityY)
end

function M:setGravityY(y)
    self:setGravity(self.gravityX, y)
end

---------------------------------------
-- unitsToMeters
---------------------------------------

function M:getUnitsToMeters()
    return self.world._unitsToMeters
end

function M:setUnitsToMeters(value)
    self.world._unitsToMeters = value
    self.world:setUnitsToMeters(value)
end

---------------------------------------
-- debugDraw
---------------------------------------

function M:setDebugDraw(value)
    self._debugDraw = value
    
    if value and self.layer then
        self.layer:setBox2DWorld(self.world)
    end
end

function M:getDebugDraw()
    return self._debugDraw
end

return M
