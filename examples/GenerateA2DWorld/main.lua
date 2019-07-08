io.stdout:setvbuf( "no" )

W, H = 1280, 720
love.window.setMode( W, H )
love.window.setTitle( "GenerateA2DWorld" )

function love.load()
	--  > Our cell size
	_cellSize = 8

	--  > A chunk size (in pixels)
	_chunkW, _chunkH = 600, 800 
	--  > Number of chunks we want to generate
	_chunks = 10 

	--  > The start Y position, used to set the first surface pos
	_surfaceY = 45
	--  > The maximal surface Y position, the algorithm won't generate surfaces above
	_maxSurfaceY = 15
	--  > The minimal surface Y position, the algorithm won't generate surfaces below
	_minSurfaceY = _chunkH/_cellSize - 15 

	camX, camY, camSpd = -_chunkW, 0, 7 -- calculate our camera position

	_seed = os.time() -- set our generation seed

	--  > Require Chunk2D 
	require( "chunk2d" ) -- place 'chunk2d.lua' in this folder to get it to work (and then Build the game)

	--  > Set some values like the seed generation, the cellSize, the chunk size (in pixels), and some 
	--  >   surfaces positions 
	Chunk2D.set( _seed, _cellSize, _chunkW, _chunkH, _surfaceY, _minSurfaceY, _maxSurfaceY ) 

	--  > Set the fill IDs, here, the layer one will be the grass (id: 1), from the layer two to six, 
	--  >   it will be the dirt (id: 2) and from the layer six to the end will be the stone (id: 3)
	Chunk2D.setFillID( { [1] = 1, [2] = 2, [6] = 3 } )

	--  > Generate the world, here, we create 10 chunks (see: '_chunks')
	world = Chunk2D.generateWorld( _chunks )
end

function love.update( dt )
	if love.keyboard.isDown( "z" ) then
		camY = camY + camSpd
	elseif love.keyboard.isDown( "s" ) then
		camY = camY - camSpd
	elseif love.keyboard.isDown( "q" ) then
		camX = camX + camSpd
	elseif love.keyboard.isDown( "d" ) then
		camX = camX - camSpd
	end
end

function love.draw()
	love.graphics.setBackgroundColor( .2, .6, .9 )
	love.graphics.translate( camX, camY ) -- draw the world with camera offset

	--  > For each chunk of our world
	for k, chunk in pairs( world ) do
		-- Draw our chunk
		for y, yv in pairs( chunk ) do
			for x, xv in pairs( yv ) do
				-- Don't draw ID 0 (optimisation)
				if xv > 0 then
					-- Set some colors for grass, dirt, stone..
					if xv == 1 then
						love.graphics.setColor( .2, .8, .2 )
					elseif xv == 2 then
						love.graphics.setColor( .4, .3, .2 )
					elseif xv == 3 then
						love.graphics.setColor( .4, .4, .4 )
					end
					-- Draw our cells
					love.graphics.rectangle( "fill", x * _cellSize + k * _chunkW, y * _cellSize, _cellSize, _cellSize )
				end

			end
		end

	end

	love.graphics.origin() -- reset offset

	love.graphics.setColor( 1, 1, 1 ) -- print some debugs below
	love.graphics.print( "Seed: " .. Chunk2D.getSeed() )
	love.graphics.print( "Cell Size: " .. _cellSize, nil, 15 )
	love.graphics.print( "Generated Chunks: " .. _chunks, nil, 30 )
	love.graphics.print( string.format( "Chunk Size: %d:%d", _chunkW, _chunkH ), nil, 45 )
end

function love.keypressed( k )
	if k == "r" then print( "-- " .. os.time() ) love.load() end -- make an other generation
end
