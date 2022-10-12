extends GrappleBody
class_name GrappleTarget


signal clicked(left_click, target)


func _on_GrappleArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("clicked", event.button_index == BUTTON_LEFT, self)
