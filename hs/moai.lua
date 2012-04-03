--==============================================================
-- Copyright (c) 2010-2011 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
--==============================================================

local function initTransform2DInterface ( interface, super )

	function interface.addRot ( self, rDelta )
		super.addRot ( self, 0, 0, rDelta )
	end
	
	function interface.getLoc ( self )
		local x, y, z = super.getLoc ( self )
		return x, y
	end
	
	function interface.getRot ( self )
		local x, y, z = super.getRot ( self )
		return z
	end

	function interface.move ( self, xDelta, yDelta, rDelta, xSclDelta, ySclDelta, length, mode )
		return super.move ( self, xDelta, yDelta, 0, 0, 0, rDelta, xSclDelta, ySclDelta, 0, length, mode )
	end

	function interface.moveLoc ( self, xDelta, yDelta, length, mode )
		return super.moveLoc ( self, xDelta, yDelta, 0, length, mode )
	end

	function interface.movePiv ( self, xDelta, yDelta, length, mode )
		return super.movePiv ( self, xDelta, yDelta, 0, length, mode )
	end
	
	function interface.moveRot ( self, rDelta, length, mode )
		return super.moveRot ( self, 0, 0, rDelta, length, mode )
	end
	
	function interface.moveScl ( self, xSclDelta, ySclDelta, length, mode )
		return super.moveScl ( self, xSclDelta, ySclDelta, 0, length, mode )
	end
	
	function interface.seek ( self, xGoal, yGoal, rGoal, xSclGoal, ySclGoal, length, mode )
		return super.seek ( self, xGoal, yGoal, 0, 0, 0, rGoal, xSclGoal, ySclGoal, 1, length, mode )
	end

	function interface.seekLoc ( self, xGoal, yGoal, length, mode )
		return super.seekLoc ( self, xGoal, yGoal, 0, length, mode )
	end

	function interface.seekPiv ( self, xGoal, yGoal, length, mode )
		return super.seekPiv ( self, xGoal, yGoal, 0, length, mode )
	end
	
	function interface.seekRot ( self, rGoal, length, mode )
		return super.seekRot ( self, 0, 0, rGoal, length, mode )
	end
	
	function interface.seekScl ( self, xSclGoal, ySclGoal, length, mode )
		return super.seekScl ( self, xSclGoal, ySclGoal, 1, length, mode )
	end
	
	function interface.setLoc ( self, x, y )
		super.setLoc ( self, x, y, 0 )
	end
	
	function interface.setRot ( self, rot )
		super.setRot ( self, 0, 0, rot )
	end
	
end

----------------------------------------------------------------
-- moai2D.lua - version 1.0 Beta
----------------------------------------------------------------

MOAILayer.extend (

	"MOAILayer2DHS",

	-- extend the instance interface
	function ( interface, super )
            initTransform2DInterface ( interface, super )
	end,
	
	-- extend the class
	function ( class, super )

        local new = class.new

		function class.new ()
            local self = new ()
			self:setPartitionCull2D ( true )
			return self
		end
	end
)

MOAITextBox.extend (

	"MOAITextBox2D",

	-- extend the instance interface
	function ( interface, super )
		initTransform2DInterface ( interface, super )
	end,
	
	-- extend the class
	function ( class, super )
	end
)