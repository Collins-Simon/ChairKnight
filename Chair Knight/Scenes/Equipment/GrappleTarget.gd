extends PhysicsBody2D


signal clicked(target)


func _on_GrappleArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("clicked", self)
