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

local Box2DWorld = PropertySupport()

Box2DWorld:setPropertyName("layer")
Box2DWorld:setPropertyName("angularSleepTolerance")
Box2DWorld:setPropertyName("autoClearForces")
Box2DWorld:setPropertyName("linearSleepTolerance")
Box2DWorld:setPropertyName("timeToSleep")
Box2DWorld:setPropertyName("gravityX")
Box2DWorld:setPropertyName("gravityY")
Box2DWorld:setPropertyName("unitsToMeters")
Box2DWorld:setPropertyName("debugDraw")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Box2DWorld:init(params)
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

function Box2DWorld:start()
    self.world:start()
end

function Box2DWorld:addBodyFromDisplay(displayObject, params)
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


function Box2DWorld:addBody(bodyType, params)
    local body = Box2DBody:new(world, self.world:addBody(bodyType))
    if params then
        table.copy(params, body)
    end
    return body
end

function Box2DWorld:addDistanceJoint(...)
    local joint = self.world:addDistanceJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function Box2DWorld:addFrictionJoint(...)
    local joint = self.world:addFrictionJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function Box2DWorld:addGearJoint(...)
    local joint = self.world:addGearJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function Box2DWorld:addMouseJoint(...)
    local joint = self.world:addMouseJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function Box2DWorld:addPrismaticJoint(...)
    local joint = self.world:addPrismaticJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function Box2DWorld:addPulleyJoint(...)
    local joint = self.world:addPulleyJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function Box2DWorld:addRevoluteJoint(...)
    local joint = self.world:addRevoluteJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function Box2DWorld:addRopeJoint(...)
    local joint = self.world:addRopeJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function Box2DWorld:addWeldJoint(...)
    local joint = self.world:addWeldJoint(...)
    table.insert(self.joints, joint)
    return joint
end

function Box2DWorld:addWheelJoint(...)
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

function Box2DWorld:getLayer()
    return self._layer
end

function Box2DWorld:setLayer(layer)
    self._layer = layer
    if self.debugDraw and layer then
        layer.renderPass:setBox2DWorld(self.world)
    end
end

---------------------------------------
-- angularSleepTolerance
---------------------------------------

function Box2DWorld:getAngularSleepTolerance()
    return self.world:getAngularSleepTolerance()
end

function Box2DWorld:setAngularSleepTolerance(value)
    self.world:setAngularSleepTolerance(value)
end

---------------------------------------
-- autoClearForces
---------------------------------------

function Box2DWorld:getAutoClearForces()
    return self.world:getAutoClearForces()
end

function Box2DWorld:setAutoClearForces(value)
    self.world:setAutoClearForces(value)
end

---------------------------------------
-- linearSleepTolerance
---------------------------------------

function Box2DWorld:getLinearSleepTolerance()
    return self.world:getLinearSleepTolerance()
end

function Box2DWorld:setLinearSleepTolerance(value)
    self.world:setLinearSleepTolerance(value)
end

---------------------------------------
-- timeToSleep
---------------------------------------

function Box2DWorld:getTimeToSleep()
    return self.world:getTimeToSleep()
end

function Box2DWorld:setTimeToSleep(value)
    self.world:setTimeToSleep(value)
end

---------------------------------------
-- gravity
---------------------------------------

function Box2DWorld:getGravity()
    return self.world:getGravity()
end

function Box2DWorld:getGravityX()
    local x, y = self.world:getGravity()
    return x
end

function Box2DWorld:getGravityY()
    local x, y = self.world:getGravity()
    return y
end

function Box2DWorld:setGravity(x, y)
    self.world:setGravity(x, y)
end

function Box2DWorld:setGravityX(x)
    self:setGravity(x, self.gravityY)
end

function Box2DWorld:setGravityY(y)
    self:setGravity(self.gravityX, y)
end

---------------------------------------
-- unitsToMeters
---------------------------------------

function Box2DWorld:getUnitsToMeters()
    return self.world._unitsToMeters
end

function Box2DWorld:setUnitsToMeters(value)
    self.world._unitsToMeters = value
    self.world:setUnitsToMeters(value)
end

---------------------------------------
-- debugDraw
---------------------------------------

function Box2DWorld:setDebugDraw(value)
    self._debugDraw = value
    
    if value and self.layer then
        self.layer:setBox2DWorld(self.world)
    end
end

function Box2DWorld:getDebugDraw()
    return self._debugDraw
end

return Box2DWorld
