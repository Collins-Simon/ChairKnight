extends Sprite

## create a rope object pointed at redefined grapple points
func rope() -> void:
	var rope : Rope = load("res://Scenes/Equipment/Rope.tscn").instance()
	rope.init($GrappleSource, $"../GrappleDest")
	get_parent().add_child(rope)

## remove the rope object created by rope()
func unrope() -> void:
	for child in get_parent().get_children():
		if child is Rope:
			child.queue_free()
			break
