local Class = require "hump.class"
local AStar = require "moneyrace.astar"
local MoneyRace = {}

MoneyRace.Tilemap = Class {
	init = function(self, image)
		self.tilesetBatch = love.graphics.newSpriteBatch(image, gameSettings.resolution.width / (gameSettings.tileSize * gameSettings.zoom) * gameSettings.resolution.height / (gameSettings.tileSize * gameSettings.zoom))

		self.quads = {}
		self.quads[0] = love.graphics.newQuad(0, 0, 16, 16, image:getWidth(), image:getHeight()) 	-- empty
		self.quads[1] = love.graphics.newQuad(16, 0, 16, 16, image:getWidth(), image:getHeight()) 	-- road
		self.quads[2] = love.graphics.newQuad(32, 0, 16, 16, image:getWidth(), image:getHeight()) 	-- road
		self.quads[3] = love.graphics.newQuad(48, 0, 16, 16, image:getWidth(), image:getHeight()) 	-- road
		self.quads[4] = love.graphics.newQuad(64, 0, 16, 16, image:getWidth(), image:getHeight()) 	-- road

		self.quads[5] = love.graphics.newQuad(80, 0, 16, 16, image:getWidth(), image:getHeight()) 	-- road
		self.quads[6] = love.graphics.newQuad(96, 0, 16, 16, image:getWidth(), image:getHeight()) 	-- road
		self.quads[7] = love.graphics.newQuad(112, 0, 16, 16, image:getWidth(), image:getHeight()) 	-- finishLeft
		self.quads[8] = love.graphics.newQuad(128, 0, 16, 16, image:getWidth(), image:getHeight()) 	-- finishUp
		self.quads[9] = love.graphics.newQuad(144, 0, 16, 16, image:getWidth(), image:getHeight()) 	-- finishDown
		self.quads[10] = love.graphics.newQuad(176, 0, 16, 16, image:getWidth(), image:getHeight()) -- finishRight
	end,
	updateTilesetBatch = function(self)
		self.tilesetBatch:clear()
		for x=1, gameSettings.resolution.width / (gameSettings.tileSize * gameSettings.zoom) do
			for y=1, gameSettings.resolution.height / (gameSettings.tileSize * gameSettings.zoom) do
				self.tilesetBatch:add(
					self.quads[self.map[y][x]],
					(x - 1) * (gameSettings.tileSize * gameSettings.zoom) + gameSettings.offset.x,
					(y - 1) * (gameSettings.tileSize * gameSettings.zoom) + gameSettings.offset.y,
					0, gameSettings.zoom
				)
			end
		end
	end,
	loadMap = function(self, map)
		self.map = map
		self:updateTilesetBatch()
	end,
	updateMap = function(self, pos, value)
		self.map[pos.y][pos.x] = value
		self:updateTilesetBatch()
	end,
	draw = function(self)
		love.graphics.draw(self.tilesetBatch)
	end,
	tile = function(self, x, y)
		return self.map[y][x]
	end,
	valid = function(self, pos)
		if (pos.y > 0 and pos.y <= #self.map) then
			if (pos.x > 0 and pos.x <= #self.map[1]) then
				return true
			end
		end
		do return false end
	end,
	blocked = function(self, pos)

		if (self:valid(pos)) then
			if (road1True) then
				--print("road1True")
				if (goingLeft) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 4) then return true end
					if (self.map[pos.y][pos.x] == 5) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					do return false end
				
				elseif (goingRight) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 2) then return true end
					if (self.map[pos.y][pos.x] == 3) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					do return false end
				
				end
				
					return true
				

			elseif (road2True) then
				if (goingRight) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 3) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					do return false end
				
				elseif (goingUp) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 5) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					do return false end
				
				end
			
					return true
				

			elseif (road3True) then
				if (goingRight) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 2) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					do return false end
				
				elseif (goingDown) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 4) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					do return false end
			
				end
				
					return true
				

			elseif (road4True) then
				if (goingLeft) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 5) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					do return false end
				
				elseif (goingDown) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 3) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					do return false end
				
				end
				
					return true
			

			elseif (road5True) then
				if (goingLeft) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 4) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					do return false end
				
				elseif (goingUp) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 2) then return true end
					if (self.map[pos.y][pos.x] == 5) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					do return false end
				
				end
				
					return true
				

			elseif (road6True) then
				if (goingUp) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 2) then return true end
					if (self.map[pos.y][pos.x] == 5) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					do return false end
				
				elseif (goingDown) then
					if (self.map[pos.y][pos.x] == 0) then return true end
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 3) then return true end
					if (self.map[pos.y][pos.x] == 4) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					do return false end
				
				end
				
					return true
				
			end
		end
		return true
	end
	
}

MoneyRace.Animation = Class {
	init = function(self, image, pos, steps, updateDelay)
		if (steps == nil) then steps = 1 end
		if (updateDelay == nil) then updateDelay = 0.1 end

		self.animationRunning = false

		self.pos = pos

		self.width = image:getWidth()
		self.height = image:getHeight()

		self.frames = {}
		self.currentFrameNumber = 1

		self.cyclesSinceLastUpdate = 0
		self.updateDelay = updateDelay

		self.frameWidth = self.width / steps
		self.frameHeight = self.height

		self:setFrames(image, steps)
	end,
	setFrames = function(self, image, steps)
		self.image = image
		for x=0, steps do
			self.frames[x+1] = love.graphics.newQuad((x*self.frameWidth), 0, self.frameWidth, self.frameHeight, self.width, self.height)
		end
	end,
	update = function(self, dt)
		if (not self.animationRunning) then return true end

		if (#self.frames == 1) then return true end
		self.cyclesSinceLastUpdate = self.cyclesSinceLastUpdate + dt
		if (self.cyclesSinceLastUpdate > self.updateDelay) then
			self.currentFrameNumber = self.currentFrameNumber + 1
			if (self.currentFrameNumber == #self.frames) then self.currentFrameNumber = 1 end
			self.cyclesSinceLastUpdate = 0
		end
	end,
	draw = function(self)
		love.graphics.draw(self.image, self.frames[self.currentFrameNumber], self.pos.x + gameSettings.offset.x, self.pos.y + gameSettings.offset.y, 0, gameSettings.zoom, gameSettings.zoom)
	end,
	start = function(self)
		self.animationRunning = true
	end,
	stop = function(self)
		self.currentFrameNumber = 1
		self.cyclesSinceLastUpdate = 0
		self.animationRunning = false
	end,
	center = function(self)
		return {x=self.pos.x+((self.frameWidth * gameSettings.zoom) / 2), y=self.pos.y+((self.frameHeight * gameSettings.zoom) / 2)}
	end
}

MoneyRace.Entity = Class {
	init = function(self, image, tilePos, steps)
		self.tilePos = tilePos
		self.pixelOffset = {x=0, y=0}
		self.sprite = MoneyRace.Animation(
			image,
			self:pixelPos(),
			steps
		)
		self.job = nil
	end,
	pixelPos = function(self)
		return {
			x = ((self.tilePos.x - 1) * gameSettings.tileSize * gameSettings.zoom) + self.pixelOffset.x,
			y = ((self.tilePos.y - 1) * gameSettings.tileSize * gameSettings.zoom) + self.pixelOffset.y
		}
	end,
	recalculateSpritePosition = function(self)
	return {
		x = ((self.tilePos.x - 1) * gameSettings.tileSize * gameSettings.zoom) + self.pixelOffset.x,
		y = ((self.tilePos.y - 1) * gameSettings.tileSize * gameSettings.zoom) + self.pixelOffset.y
	}
	end,
 	draw = function(self)
		self.sprite.pos = self:pixelPos()
		self.sprite:draw()
	end,
	update = function(self, dt)
		self.sprite:update(dt)
		if (self.job) then
			local jobResult = self.job:update(dt)
			if (not jobResult) then self.job=nil end
		end
	end,
	giveJob = function(self, name, options)
		-- load a dynamic class based on "name" variable
		self.job = MoneyRace[name](self, options)
	end
}

MoneyRace.Survivor = Class {
	__includes = MoneyRace.Entity,
	init = function(self, pos, raceTime)
		self.normalImage = love.graphics.newImage("tileset/spaceman.png")
		--self.hiliteImage = love.graphics.newImage("tileset/spaceman-hilite.png")
		self.raceTime = raceTime
		MoneyRace.Entity.init(self, self.normalImage, pos, 4)
		self.speed = 250
	end,
	setUnselect = function(self)
		self.selected = false
		self.sprite:setFrames(self.normalImage, 4)
	end,
	setSelect = function(self)
		self.selected = true
		--self.sprite:setFrames(self.hiliteImage, 4)
	end,
	arrive = function(self, pos)
		--self.tilePosCache = self:tilePos()
		--aankomen op de basis (bezorgen)
		--MoneyRace.Entity.update(self, dt)
	local tileType = tilemap:tile(pos.x,pos.y)
		if (tileType == 7 or tileType == 8 or tileType == 9 or tileType == 10) then
			levelManager:levelFinished()
		end
	return false
	end,
	giveJob = function(self, name, options)
		-- load a dynamic class based on "name" variable
		options.speed = self.speed
		self.job = MoneyRace[name](self, options)
	end,
	giveJobIfReady = function(self, name, options)
		if (self.job == nil) then
			self:giveJob(name, options)
			return true
		end
		return false
	end
}

MoneyRace.Job = Class {
	init = function(self, actor, options)
		self.actor = actor
		self.cyclesSinceLastUpdate = 0
		self.updateDelay = 0.1
		self.options = options
	end,
	update = function(self, dt)
		local jobResult = self:process(dt)
		if (not jobResult) then return false end
		return true
	end,
	process = function(self, dt)
		return false
	end
}

MoneyRace.WalkPath = Class {
	__includes = MoneyRace.Job,
	init = function(self, actor, options)
		MoneyRace.Job.init(self, actor, options)
		--local currentPos = self.actor.sprite.pos
		--if (#self.options.path > 1) then table.remove(self.options.path, 1) end

		--local goalTile = self.options.path[1]
		--if (currentPos.x == goalTile.pos.x and currentPos.y == goalTile.pos.y) then table.remove(self.options.path, 1) end

		self.speed = 150
		if (self.options.speed) then self.speed = self.options.speed end
		self.actor.sprite:start()
	end,
	process = function(self, dt)
		local currentTilePos = self.actor.tilePos
		local currentPixelOffset = self.actor.pixelOffset
		local goalTilePos = self.options.path[1].pos

		if currentTilePos.x == goalTilePos.x and currentTilePos.y == goalTilePos.y then
			if (currentPixelOffset.x == 0 and currentPixelOffset.y == 0) then
				table.remove(self.options.path,1)
				if (#self.options.path == 0) then
					self.actor.sprite:stop()
					return self.actor:arrive(goalTilePos)
				end
			return true
			end
		end

		local movement = self.speed * dt
		local maxPixelOffset 	= gameSettings.tileSize * gameSettings.zoom
		local minPixelOffset 	= -1 * maxPixelOffset

		-- naar links
		if currentTilePos.x > goalTilePos.x then
			currentPixelOffset.x = currentPixelOffset.x-movement
		end
		-- naar rechts
		if currentTilePos.x < goalTilePos.x then
			currentPixelOffset.x = currentPixelOffset.x+movement
		end
		-- omhoog
		if currentTilePos.y > goalTilePos.y then
			currentPixelOffset.y = currentPixelOffset.y-movement
		end
		-- omlaag
		if currentTilePos.y < goalTilePos.y then
			currentPixelOffset.y = currentPixelOffset.y+movement
		end

		currentPixelOffset.x = math.max(minPixelOffset, math.min(maxPixelOffset, currentPixelOffset.x))
		currentPixelOffset.y = math.max(minPixelOffset, math.min(maxPixelOffset, currentPixelOffset.y))

		if (currentPixelOffset.x >= maxPixelOffset) then
			self.actor.tilePos.x = self.actor.tilePos.x + 1
			currentPixelOffset.x = 0
		end
		if (currentPixelOffset.x <= minPixelOffset) then
			self.actor.tilePos.x = self.actor.tilePos.x - 1
			currentPixelOffset.x = 0
		end
		if (currentPixelOffset.y >= maxPixelOffset) then
			self.actor.tilePos.y = self.actor.tilePos.y + 1
			currentPixelOffset.y = 0
		end
		if (currentPixelOffset.y <= minPixelOffset) then
			self.actor.tilePos.y = self.actor.tilePos.y - 1
			currentPixelOffset.y = 0
		end

		self.actor.pixelOffset = currentPixelOffset
		return true
	end
}
MoneyRace.Wait = Class {
	__includes = MoneyRace.Job,
	init = function(self, actor, options)
		MoneyRace.Job.init(self, actor, options)
		self.timeout = 0;
	end,
	process = function(self, dt)
		self.timeout = self.timeout + dt
		if (self.timeout > 0.25) then return false end
		return true
	end
}

return MoneyRace
