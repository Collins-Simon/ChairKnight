extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var adjacentrooms = [null, null, null, null]
onready var coords = [0,0]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func doorsOpened():
	for col in 25:
		for row in 25:
			if(get_cell(col, row) in [4, 6]):
				set_cell(col, row, 5)

func closeDoors():
	set_cell(0, 10, 4)
	set_cell(0, 11, 6)
	set_cell(20, 10, 4)
	set_cell(20, 11, 6)
	set_cell(10, 0, 4)
	set_cell(10, 1, 6)
	set_cell(10, 20, 4)
	set_cell(10, 21, 6)

func createCorridors():
	var corridor = load("res://Scenes/Environment/Corridor.tscn")
	var orientations = [[208, 320, 90], [144, 32, 270], [-400, 144, 0], [320, 144, 0]]
	for orientation in orientations:
		var instance = corridor.instance()
		instance.position = Vector2(orientation[0],orientation[1])
		instance.scale = Vector2(1, 1)
		instance.rotation = deg2rad(orientation[2])
		instance
		add_child(instance)

func roomCleared():
	doorsOpened()
	createCorridors()
