extends TileMap

onready var coords = [0,0]

#Replaces door tiles with floor tiles, called on clearing a level.
func doorsOpened():
	for col in 25:
		for row in 25:
			if(get_cell(col, row) in [4, 6]):
				set_cell(col, row, 5)

#Places door tiles at specified coordinated, called on entering a previously unvisited level.
func closeDoors():
	set_cell(0, 10, 4)
	set_cell(0, 11, 6)
	set_cell(20, 10, 4)
	set_cell(20, 11, 6)
	set_cell(10, 0, 4)
	set_cell(10, 1, 6)
	set_cell(10, 20, 4)
	set_cell(10, 21, 6)

#Place all tiles provided via an array of triplets; each coords contains x, y, and tile index.
func placeAll(coordsSet):
	for coords in coordsSet:
		set_cell(coords[0], coords[1], coords[2])

#Place wall tiles in a rectangle at the provided dimensions, where x and y define the rectangles top left corner.
func placeSquare(x, y, width, height):
	for wide in width:
		for high in height:
			set_cell(x+wide, y+high, 1)

#Place wall tiles in an array of variants to add variety to gameplay.
func addObstacles():
	#Rounded corners, 50% chance
	var version = rand_range(0, 1)
	if(version <= 0.5):
		placeAll([[2,2,1],[2,3,1],[3,2,1],[19,19,1],[18,19,1],[19,18,1],[2,19,1],[3,19,1],[2,18,1],[19,2,1],[19,3,1],[18,2,1]])
	version = rand_range(0, 5)
	if(version <=1):
		#Place four walls in square near centre of room
		placeAll([[8, 8, 1],[12,12,1],[8,12,1],[12,8,1]])
	elif(version <=2):
		#Place four walls haphazardly through room
		placeAll([[7,10,1],[12,4,1],[14,11,1],[3,12,1]])
	elif(version <=3):
		#Place wall in square pattern towards outside of room
		placeAll([[5,5,1],[5,8,1],[5,11,1],[5,14,1],[5,17,1],[8,5,1],[11,5,1],[14,5,1],[17,5,1],[17,8,1],[17,11,1],[17,14,1],[17,17,1],[14,17,1],[11,17,1],[8,17,1]])
	elif(version <=4):
		#Build large wall to create a 'donut' shaped room
		placeSquare(7, 7, 8, 8)

#Generate four corridors, one in place of each door, activated on completion of a level
func createCorridors():
	var corridor = load("res://Scenes/Environment/Corridor.tscn")
	var orientations = [[208, 320, 90], [144, 32, 270], [-400, 144, 0], [320, 144, 0]]
	for orientation in orientations:
		var instance = corridor.instance()
		instance.position = Vector2(orientation[0],orientation[1])
		instance.scale = Vector2(1, 1)
		instance.rotation = deg2rad(orientation[2])
		call_deferred("add_child", instance)

#Called on room completion, activates other functions.
func roomCleared():
	doorsOpened()
	createCorridors()
