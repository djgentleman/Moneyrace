local Gamestate = require "hump.gamestate"
local MoneyRace = require "moneyrace.classes"
local AStar = require "moneyrace.astar"
local LevelManager = require "moneyrace.levelmanager"

menu = {}
game = {}
nextLevelScreen = {}
levelFinishedScreen= {}

levelManager = {}
survivors = {}
enemies = {}
decals = {}
goingLeft = false
goingRight = false
goingUp = false
goingDown = false
road1True = false
road2True = false
road3True = false
road4True = false
road5True = false
road6True = false
touchReleased = false
touchPressX = 0
touchPressY = 0
deltaX = 0
deltaY = 0

player = {
	totalScore=0,
	gold=0,
	time=0,
	dragStart=false
}

gameSettings = {
	--resolution={width=640,height=512},
	resolution={width=0,height=0},
	offset={x=0,y=0},
	tilesHorizontal=20,
	tilesVertical=16,
	tileSize=16,
	zoom=2
}

--levelStartTime = 0

function love.load()
--	for i=1, 99 do love.math.random() end
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setMode(gameSettings.resolution.width, gameSettings.resolution.height, {fullscreen=true})
	updateResolution()

	levelManager = LevelManager()
	Gamestate.registerEvents()
	Gamestate.switch(game)

	if love.filesystem.exists("hiscore.txt") then
		player.hiScore = love.filesystem.read("hiscore.txt")
	else
		player.hiScore = 0
	end

	--if (not (type(player.hiScore) == "number"))  then player.hiScore = 0 end
	--player.hiScore = tonumber(player.hiScore)
	player.hiScore = math.floor(player.hiScore)

	--tilemap = MoneyRace.Tilemap(love.graphics.newImage("tileset/tilemap.png"), {{0}})

end

function updateResolution()
	width, height = love.window.getDimensions()

	local desiredTileSize = 0
	if (width > height) then
		desiredTileSize = 32 -- math.floor(height / gameSettings.tilesVertical)
	else
		desiredTileSize = 32 --math.floor(width / gameSettings.tilesHorizontal)
	end

	gameSettings.zoom=math.max(1, math.floor(desiredTileSize / gameSettings.tileSize * 10) / 10)

	gameSettings.resolution.width = math.ceil(gameSettings.tilesHorizontal * gameSettings.tileSize * gameSettings.zoom)
	gameSettings.resolution.height = math.ceil(gameSettings.tilesVertical * gameSettings.tileSize * gameSettings.zoom)

	gameSettings.offset.x = math.floor(width - gameSettings.resolution.width) / 2
	gameSettings.offset.y = math.floor(height - gameSettings.resolution.height) / 2

	if (gameSettings.resolution.width < 640) then
		mainFont = love.graphics.newFont("font/Sniglet-ExtraBold.otf", 15);
		storyFont = love.graphics.newFont("font/Sniglet-ExtraBold.otf", 40);
	else
		mainFont = love.graphics.newFont("font/Sniglet-ExtraBold.otf", 20);
		storyFont = love.graphics.newFont("font/Sniglet-ExtraBold.otf", 50);
	end

end

function game:enter()
	love.graphics.setFont(mainFont);
	--levelStartTime = love.timer.getTime()
	levelManager:loadLevel()

end

function game:update(dt)

	local selectedSurvivor = nil
	for x=1, #survivors do
		survivors[x]:update(dt)
		if (survivors[x].selected) then

		end
	selectedSurvivor = survivors[x]
	end

	--local mouseX, mouseY = love.mouse.getPosition()
	--if (not player.dragStart) then
	--		player.dragStart = {x=mouseX, y=mouseY}
	--end

	if (selectedSurvivor and touchReleased) then


		if (math.abs(deltaX) > 50 or math.abs(deltaY) > 50) then
			local posCache = selectedSurvivor.tilePos
			local tile_selected_x = posCache.x
			local tile_selected_y = posCache.y

			if (math.abs(deltaX) > math.abs(deltaY)) then
				if (deltaX > 0) then
				--	print("going left")
					goingLeft = true
					tile_selected_x = tile_selected_x - 1
				else
				--	print("going right")
					goingRight = true
					tile_selected_x = tile_selected_x + 1
				end
			elseif (math.abs(deltaY) > math.abs(deltaX)) then
				if (deltaY > 0) then
				--	print("going up")
					goingUp = true
					tile_selected_y = tile_selected_y - 1
				else
				--	print("going down")
					goingDown = true
					tile_selected_y = tile_selected_y + 1
				end
			end
			local tile = tilemap:tile(selectedSurvivor.tilePos.x,selectedSurvivor.tilePos.y)
			
			if (tile == 1) then
				road1True = true
			elseif (tile == 2) then
				road2True = true
			elseif (tile == 3) then
				road3True = true
			elseif (tile == 4) then
				road4True = true
			elseif (tile == 5) then
				road5True = true
			elseif (tile == 6) then
				road6True = true
			end
			--tile_type = tilemap:tile(tile_selected_x,tile_selected_y)
		--	print("type ",tile_type, " road ", road1True)
			--if (tilemap:blocked({x=tile_selected_x,y=tile_selected_y})) then return false end

			path = AStar:findFromEntity(selectedSurvivor, {x=tile_selected_x, y=tile_selected_y})

			if (selectedSurvivor:giveJobIfReady("WalkPath", {path=path})) then
				--print("go to ", tile_selected_x, tile_selected_y)
			end

			--player.dragStart = nil
			touchReleased = false
			road1True = false
			road2True = false
			road3True = false
			road4True = false
			road5True = false
			road6True = false
			goingRight = false
			goingLeft = false
			goingUp = false
			goingDown = false
		end
	end
	--player.time = math.floor((love.timer.getTime() - levelStartTime))
	--self.raceTime= self.raceTime - 10
	return true
end

function game:mousepressed(x, y)
	touchPressX = x*love.graphics.getWidth()
	touchPressY = y*love.graphics.getHeight()
end

function game:mousereleased(x, y)
	
	deltaX = touchPressX - (x*love.graphics.getWidth())
	deltaY = touchPressY - (y*love.graphics.getHeight())
	touchReleased = true
	
end

function game:keypressed(key)
	if (key == "n") then
		levelManager.currentLevel = levelManager.currentLevel + 1
		Gamestate.switch(levelFinishedScreen)
	end
end

function game:draw()
	-- draw map
	tilemap:draw()

	-- draw survivors
	for x=1, #survivors do
		survivors[x]:draw()
	end

	love.graphics.setColor(0,0,0)
	local line = " TIME " .. player.time .. "             SCORE " .. player.totalScore .. "/" .. math.max(0, player.hiScore)
	local lineW = mainFont:getWidth(line)
	love.graphics.print(line, (gameSettings.resolution.width/2)-(lineW/2)+gameSettings.offset.x, 2 + gameSettings.offset.y)
	love.graphics.reset()
end

function game:resize(w,h)
	updateResolution()
	tilemap:updateTilesetBatch()
	for x=1, #survivors do
		survivors[x]:recalculateSpritePosition()
	end
end


function levelFinishedScreen:enter()
	love.graphics.setFont(mainFont);
	player.totalScore = math.floor((player.wood * 100 + player.rope * 120) / player.time * 10) + player.totalScore

	if (player.totalScore > player.hiScore) then
		love.filesystem.write( "hiscore.txt", player.totalScore )
		player.hiScore = player.totalScore
	end
end

function levelFinishedScreen:draw()
	love.graphics.setColor(255,255,255)

	local text = {
		"LEVEL " .. levelManager.currentLevel,
		"Time bonus: " .. math.floor((100 + 120) / player.time * 10),
		"Total: " .. player.totalScore -
		( (100) + (120) + math.floor((100 + 120) / player.time * 10) )
		.. " + " ..
		( (100) + (120) + math.floor((100 + 120) / player.time * 10) )
		.. " = " ..
		player.totalScore
	}
	for t=1, #text do
		local lineW = mainFont:getWidth(text[t])
		love.graphics.print(text[t], (gameSettings.resolution.width/2)-(lineW/2)+gameSettings.offset.x, math.floor(0.1 * gameSettings.resolution.height) + t * 50 + gameSettings.offset.y)
	end
	love.graphics.reset()
end

function levelFinishedScreen:mousepressed(x, y, button)
	levelManager.currentLevel = levelManager.currentLevel + 1
	Gamestate.switch(game)
end
