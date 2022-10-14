extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var enemyarr = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func doorsOpened():
	for col in 25:
		for row in 25:
			if(get_cell(col, row) == 4):
				set_cell(col, row, -1)

func roomCleared():
	doorsOpened()
