extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var enemyarr = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func doorsOpened():
	for col in 25:
		for row in 25:
			if(get_cell(col, row) == 4):
				set_cell(col, row, -1)

func createCorridors():
	var corridor = load("res://Scenes/Environment/Corridor.tscn")
	var orientations = [[208, 320, 90], [144, 32, 270], [-400, 144, 0], [320, 144, 0]]
	for orientation in orientations:
		var instance = corridor.instance()
		instance.position = Vector2(orientation[0],orientation[1])
		instance.scale = Vector2(1, 1)
		instance.rotation = deg2rad(orientation[2])
		add_child(instance)

func roomCleared():
	doorsOpened()
	createCorridors()
