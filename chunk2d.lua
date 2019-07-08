
module( "Chunk2D", package.seeall )

author = "Guthen"
version = "1.0.0"

local seed = 0
local cellSize = 8
local chunkW, chunkH = 600, 800 
local surfaceY = 30
local minSurfaceY = chunkH/cellSize - 15
local maxSurfaceY = 5
local fillIDs = 
	{
		[1] = 1,
		[2] = 2,
	}

math.randomseed( seed )

--[[-------------------------------------------------------------------------
	--  > get config
---------------------------------------------------------------------------]]

function getSeed()
	return seed
end

function getCellSize()
	return cellSize
end

function getChunkSize()
	return chunkW, chunkH
end

function getSurfaceValues()
	return surfaceY, minSurfaceY, maxSurfaceY
end

function getFillSurfaces()
	return fillIDs
end

--[[-------------------------------------------------------------------------
	--  > config
---------------------------------------------------------------------------]]

function set( _seed, _cellSize, _chunkW, _chunkH, _startY, _minY, _maxY )
	seed = _seed or seed
	cellSize = _cellSize or cellSize
	chunkW = _chunkW or chunkW
	chunkH = _chunkH or chunkH
	surfaceY = _startY or surfaceY
	minSurfaceY = _minY or minSurfaceY
	maxSurfaceY = _maxY or maxSurfaceY

	if _seed then
		math.randomseed( seed )
	end
end

function setFillID( _IDs )
	fillIDs = _IDs or fillIDs
end

--[[-------------------------------------------------------------------------
	--  > chunks & world
---------------------------------------------------------------------------]]

--  > Create Empty Chunk 
function createEmptyChunk()
	local _chunk = {}
	for y = 0, chunkH/cellSize do
		_chunk[y] = {}
		for x = 0, chunkW/cellSize do
			_chunk[y][x] = 0
		end
	end
	return _chunk
end

--  > Get SurfaceY Position of the '_chunk' by given '_x' 
function getSurfaceY( _chunk, _x )
	if _x < 0 then return end
	for y, yv in pairs( _chunk ) do
		for x, xv in pairs( yv ) do
			if _x == x then
				if xv > 0 then return y end
			end
		end
	end
end

--  > Create & Generate a chunk by using the '_lastChunk'
function generateChunk( _chunk, _lastChunk )
	local function fillChunk()
		for x = 0, chunkW/cellSize do
			local y = getSurfaceY( _chunk, x )

			if y then
				local b = 0
				local surface = fillIDs[2] 
				for _y = y+1, H/cellSize do 
	 				_chunk[_y][x] = surface
		 			b = b + 1
		 			if b > 1 and fillIDs[b] then
		 				surface = fillIDs[b]
		 			end
		 		end
		 	end
		end
	end

	for x = 0, chunkW/cellSize do -- generate the surface
		
		local _y
		if _lastChunk and x == 1 then
			_y = getSurfaceY( _lastChunk, chunkW/cellSize )
		else
			_y = getSurfaceY( _chunk, x-1 )
		end

		if _y then
			local offset = math.random( -1, 1 ) -- get the Y offset
			if _chunk[_y + offset] and _chunk[_y + offset][x] then -- if it's exists
				if _y + offset < maxSurfaceY or _y + offset > minSurfaceY then
					offset = 0
				end
				_chunk[_y + offset][x] = fillIDs[1]
			end
		elseif not _lastChunk then
			_chunk[surfaceY][x] = fillIDs[1]
		end

	end

	smoothChunk( _chunk, _lastChunk )
	fillChunk()
end

--  > Create & Generate a world of 'nChunks' chunks
function generateWorld( nChunks )
	local world = {}
	for i = 1, nChunks do
		world[i] = createEmptyChunk()
		generateChunk( world[i], world[i-1] )
	end
	return world
end

--  > Smooth the chunk
function smoothChunk( _chunk, _lastChunk )
	for x = 0, chunkW/cellSize do -- smoothness

		local activeChunk = _chunk

		local y, _y, __y, ___y
		y = getSurfaceY( _chunk, x )

		if _lastChunk and not _chunk[x-1] then
			_y = getSurfaceY( _lastChunk, chunkW/cellSize-1 )
			activeChunk = _lastChunk
		else
			_y = getSurfaceY( _chunk, x-1 )
		end
		if _lastChunk and not _chunk[x-2] then
			__y = getSurfaceY( _lastChunk, chunkW/cellSize-2 )
			activeChunk = _lastChunk
		else
			__y = getSurfaceY( _chunk, x-2 )
		end
		if _lastChunk and not _chunk[x-3] then
			___y = getSurfaceY( _lastChunk, chunkW/cellSize-3 )
			activeChunk = _lastChunk
		else
			___y = getSurfaceY( _chunk, x-3 )
		end

		if y and _y and __y then
			if y == __y and not (_y == y) and math.abs( y - _y ) <= 1 and activeChunk[y] then -- if : '0 - 1 - 0' or : '1 - 0 - 1'
				if _y and y and _y < y then activeChunk[_y][x-1] = 0 end
				activeChunk[y][x-1] = 1
			elseif y == ___y and _y == __y and not y == _y then
				activeChunk[y][x-1] = 2
				activeChunk[y][x-2] = 2
			end
		end

	end
end

-- Smooth all of the world chunks 
function smoothWorld( world )
	for id = 1, #world do -- smoothness
		local curChunk = world[id]
		local lastChunk = world[id-1]

		smoothChunk( curChunk, lastChunk )
	end
end