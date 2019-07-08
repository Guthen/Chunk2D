# Chunk2D
Small library to create 2D worlds and chunks in side-view.

## Demonstration
https://www.youtube.com/watch?v=wIlSTnrnH3I

## How to use it ?
I recommand to you to check the given examples, they are better explained.

You, first, should require 'chunk2d.lua' :
```lua
--  > Require Chunk2D 
require( "chunk2d" )
```
Then you need to set some values by using :
```lua
--  > Set some values like the seed generation, the cellSize, the chunk size (in pixels), and some 
--  >   surfaces positions  
Chunk2D.set( seed, cellSize, chunkWidth, chunkH, startSurfaceY, minimalSurfaceY, maxSurfaceY )
```
Then, you need to set the fill IDs, it used to set the specific id at a specific layer :
```lua
--  > Set the fill IDs, here, the layer one will be the grass (id: 1), from the layer two to six, 
--  >   it will be the dirt (id: 2) and from the layer six to the end will be the stone (id: 3)
Chunk2D.setFillID( { [1] = 1, [2] = 2, [6] = 3 } )
```
And then you will be able to generate the world :
```lua
--  > Generate the world, here, we create 'n' chunks
world = Chunk2D.generateWorld( n )
```

There it is, your world is created, you just have to draw it. (check the examples)

## Contact

Join this Discord : https://discord.gg/grTTWbh
