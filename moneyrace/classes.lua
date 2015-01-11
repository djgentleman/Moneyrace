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
	blocked = function(self, pos)

		if (self:valid(pos)) then
			if (road1True) then
				if (goingLeft) then
					if (self.map[pos.y][pos.x] == 4) then return true end
					if (self.map[pos.y][pos.x] == 5) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					road1True = false
					goingLeft = false
					do return false

					end
				elseif (goingRight) then
					if (self.map[pos.y][pos.x] == 2) then return true end
					if (self.map[pos.y][pos.x] == 3) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					road1True = false
					goingRight = false
					do return false
					end
				else
					road1True = false
					return true
				end

			elseif (road2True) then
				if (goingRight) then
					if (self.map[pos.y][pos.x] == 3) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					road2True = false
					goingRight = false
					do return false end
				elseif (goingUp) then
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 5) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					road2True = false
					goingUp = false
					do return false end
				else
					road2True = false
					return true
				end

			elseif (road3True) then
				if (goingRight) then
					if (self.map[pos.y][pos.x] == 2) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					road3True = false
					goingRight = false
					do return false end
				elseif (goingDown) then
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 4) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					road3True = false
					goingDown = false
					do return false end
				else
					road3True = false
					return true
				end

			elseif (road4True) then
				if (goingLeft) then
					if (self.map[pos.y][pos.x] == 5) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					road4True = false
					goingLeft = false
					do return false end
				elseif (goingDown) then
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 3) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					road4True = false
					goingDown = false
					do return false end
				else
					road4True = false
					return true
				end

			elseif (road5True) then
				if (goingLeft) then
					if (self.map[pos.y][pos.x] == 4) then return true end
					if (self.map[pos.y][pos.x] == 6) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					road5True = false
					goingLeft = false
					do return false end
				elseif (goingUp) then
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 2) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					road5True = false
					goingUp = false
					do return false end
				else
					road5True = false
					return true
				end

			elseif (road6True) then
				if (goingUp) then
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 2) then return true end
					if (self.map[pos.y][pos.x] == 5) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 9) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					road6True = false
					goingUp = false
					do return false end
				elseif (goingDown) then
					if (self.map[pos.y][pos.x] == 1) then return true end
					if (self.map[pos.y][pos.x] == 3) then return true end
					if (self.map[pos.y][pos.x] == 4) then return true end
					if (self.map[pos.y][pos.x] == 7) then return true end
					if (self.map[pos.y][pos.x] == 8) then return true end
					if (self.map[pos.y][pos.x] == 10) then return true end
					road6True = false
					goingDown = false
					do return false end
				else
					road6True = false
					return true
				end
			end
		end
		return true
	end,
	valid = function(self, pos)
		if (pos.y > 0 and pos.y <= #self.map) then
			if (pos.x > 0 and pos.x <= #self.map[1]) then
				return true
			end
		end
		do return false end
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
	intersect = function(self, x, y)
		if (
			x>=self.pos.x and x<=self.pos.x+(self.frameWidth * gameSettings.zoom) and
			y>=self.pos.y and y<=self.pos.y+(self.frameHeight * gameSettings.zoom)
			) then
			return true
		end
	end,
	center = function(self)
		return {x=self.pos.x+((self.frameWidth * gameSettings.zoom) / 2), y=self.pos.y+((self.frameHeight * gameSettings.zoom) / 2)}
	end
}

MoneyRace.Entity = Class {
	init = function(self, image, pos, steps)
		self.sprite = MoneyRace.Animation(
			image,
			{x=(pos.x-1)*gameSettings.tileSize*gameSettings.zoom, y=(pos.y-1)*gameSettings.tileSize*gameSettings.zoom},
			steps
		)
		self.job = nil
		self.dead = false
		self.tilePosCache = self:tilePos()
	end,
	tilePos = function(self)
		local tile_x = math.floor(self.sprite.pos.x * 1000 / (gameSettings.tileSize * gameSettings.zoom * 1000)) + 1
		local tile_y = math.floor(self.sprite.pos.y * 1000 / (gameSettings.tileSize * gameSettings.zoom * 1000)) + 1
		--print("tilepos", tile_x, tile_y)
		return {x = tile_x, y=tile_y}
	end,
	recalculateSpritePosition = function(self)
		self.sprite.pos = {
			x=(self.tilePosCache.x-1)*(gameSettings.tileSize*gameSettings.zoom),
			y=(self.tilePosCache.y-1)*(gameSettings.tileSize*gameSettings.zoom)
		}
	end,
 	draw = function(self)
	 	if (self.dead) then return false end
		self.sprite:draw()
	end,
	update = function(self, dt)
		if (self.dead) then return false end
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
		MoneyRace.Entity.init(self, self.normalImage, pos, 4, raceTime)


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
	arrive = function(self, x, y)
		--self.tilePosCache = self:tilePos()
		--aankomen op de basis (bezorgen)
		local tile = tilemap:tile(x,y)
		if (tile == 7 or tile == 8 or tile == 9 or tile == 10) then
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
		local currentPos = self.actor.sprite.pos
		--if (#self.options.path > 1) then table.remove(self.options.path, 1) end

		local goalTile = self.options.path[1]
		if (currentPos.x == goalTile.pos.x and currentPos.y == goalTile.pos.y) then table.remove(self.options.path, 1) end

		self.speed = 150
		if (self.options.speed) then self.speed = self.options.speed end
		self.actor.sprite:start()
	end,
	process = function(self, dt)
		local currentPos = self.actor.sprite.pos
		local goalTile = self.options.path[1]

		local goalPos = {
			x=(goalTile.pos.x-1)*gameSettings.tileSize*gameSettings.zoom,
			y=(goalTile.pos.y-1)*gameSettings.tileSize*gameSettings.zoom
		}

		if currentPos.x==goalPos.x and currentPos.y==goalPos.y then
			table.remove(self.options.path,1)
			self.actor.tilePosCache = self.actor:tilePos()
			if (#self.options.path == 0) then
				self.actor.sprite:stop()
				return self.actor:arrive(goalTile.pos.x,goalTile.pos.y)
			end
			return true
		end

		local movement = self.speed * dt

		if currentPos.x > goalPos.x then
			currentPos.x = math.max(currentPos.x-movement, goalPos.x)
		end
		if currentPos.x < goalPos.x then
			currentPos.x = math.min(currentPos.x+movement, goalPos.x)
		end
		if currentPos.y > goalPos.y then
			currentPos.y = math.max(currentPos.y-movement, goalPos.y)
		end
		if currentPos.y < goalPos.y then
			currentPos.y = math.min(currentPos.y+movement, goalPos.y)
		end

		self.actor.sprite.pos = currentPos
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
