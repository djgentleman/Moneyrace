local Class = require "hump.class"
local AStar = {}

AStar.node = Class {
	parent = nil,
	init = function(self, pos, parent)
		self.pos = pos
		self.parent = parent
	end,
	neighbors = function(self)
		map_w = #tilemap.map[1]
		map_h = #tilemap.map

		neighbors = {}
		if (self.pos.x + 1 <= map_w) then
			table.insert(neighbors, AStar.node(
				{x=self.pos.x+1, y=self.pos.y},
				self
			))
		end
		if (self.pos.x - 1 > 0) then
			table.insert(neighbors, AStar.node(
				{x=self.pos.x-1, y=self.pos.y},
				self
			))
		end
		if (self.pos.y + 1 <= map_h) then
			table.insert(neighbors, AStar.node(
				{x=self.pos.x, y=self.pos.y+1},
				self
			))
		end
		if (self.pos.y - 1 > 0) then
			table.insert(neighbors, AStar.node(
				{x=self.pos.x, y=self.pos.y-1},
				self
			))
		end
		return neighbors
	end,
	match = function(self, otherNode)
		if (self.pos.x == otherNode.pos.x and self.pos.y == otherNode.pos.y) then return true end
		return false
	end,
	blocked = function(self)
		if (tilemap:blocked({x=self.pos.x,y=self.pos.y})) then return true end
		return false
	end,
	distance = function(self, endPos)
		return math.sqrt(math.pow(self.pos.x - endPos.x, 2) + math.pow(self.pos.y - endPos.y, 2))
	end,
	__tostring = function(self)
		return "AStarNode: " .. self.pos.x .. ", " .. self.pos.y .. ", parent: " .. type(self.parent)
	end
}

function AStar:findFromEntity(entity, endPos)
	local currentTile = entity.tilePos
	local currentPixelPos = entity.sprite.pos

	--if (currentPixelPos.x ~= currentTile.x * (gameSettings.tileSize * gameSettings.zoom) ) then
		-- x beweegt
	return AStar:find(currentTile, endPos)

end

function AStar:find(startPos, endPos, options)
	closedList = {}
	openList = {}
	table.insert(openList, AStar.node(startPos))
    --print("astar", startPos.x, startPos.y, endPos.x, endPos.y)
	
	local node = false
	local safety = 0
	while (#openList>0) do
		safety = safety + 1
		if (safety > 999) then
		--	print ("Astar took too long?!")
			break
		end

		local nodeIndex = false
		for n=1, #openList do
			if (nodeIndex  == false or (openList[n]:distance(endPos)<node:distance(endPos))) then
				node = openList[n]
				nodeIndex = n
			end
		end

		if (node.pos.x == endPos.x and node.pos.y == endPos.y) then
			break
		end

		table.insert(closedList, node)
		table.remove(openList, nodeIndex)

		neighbors = node:neighbors()

		for n=1, #neighbors do
			local blocked = true

			blocked = neighbors[n]:blocked()
			
			if (blocked) then
				-- if blocked, then just skip
				table.insert(closedList, neighbors[n])
			else
				-- else, put on open list unless closed
				isClosed = false
				for c=1,#closedList do
					if (closedList[c]:match(neighbors[n])) then
						isClosed = true
						break
					end
				end

				isOpen = false
				for o=1,#openList do
					if (openList[o]:match(neighbors[n])) then
						isOpen = true
						break
					end
				end

				if (not isClosed and not isOpen) then
					table.insert(openList, neighbors[n])
				end
			end
		end
	end

	if (node.pos.x ~= endPos.x or node.pos.y ~= endPos.y) then
		return {AStar.node(startPos)}
	end

	path = {}
	while (node.parent) do
		table.insert(path, 1, node)
		node = node.parent
	end

	table.insert(path, 1, node)

	return path
end

return AStar