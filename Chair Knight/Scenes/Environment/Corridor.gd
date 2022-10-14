extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var rooms = [null, null]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setRooms(a, b):
	rooms[0] = a
	rooms[1] = b

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
