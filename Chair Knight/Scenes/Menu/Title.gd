extends Sprite



func rope() -> void:
	assert($GrappleSource != null)
	assert($"../GrappleDest" != null)
	var rope : Rope = load("res://Scenes/Equipment/Rope.tscn").instance()
	rope.init($GrappleSource, $"../GrappleDest")
	get_parent().add_child(rope)
	assert(rope is Rope)
	print("rope ", rope, rope.global_position)

func unrope() -> void:
#	for child in get_children():
#		if child is Rope:
#			child.start_body.queue_free()
#			child.end_body.queue_free()
#			child.queue_free()
	
	var rope : Rope
	for child in get_parent().get_children():
		if child is Rope:
#			child.start_body.queue_free()
#			child.end_body.queue_free()
			child.queue_free()
			rope = child
			break
#	var rope : Rope = get_child(1)
	print("unrope ", rope.global_position)
#	print_tree_pretty()
#	yield(get_tree(), "idle_frame")
#	print_tree_pretty()
