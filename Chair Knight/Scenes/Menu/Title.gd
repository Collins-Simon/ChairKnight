extends Sprite

func rope() -> void:
	var rope : Rope = load("res://Scenes/Equipment/Rope.tscn").instance()
	rope.init($GrappleSource, $"../GrappleDest")
	get_parent().add_child(rope)

func unrope() -> void:
	var rope : Rope
	for child in get_parent().get_children():
		if child is Rope:
			child.queue_free()
			rope = child
			break
