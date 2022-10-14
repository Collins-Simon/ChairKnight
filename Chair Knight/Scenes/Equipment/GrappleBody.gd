extends RigidBody2D
class_name GrappleBody


var attached_ropes := []
var prev_velocity := Vector2.ZERO

signal clicked(left_click, target)
signal destroyed(body)


func _physics_process(delta: float) -> void:
	prev_velocity = linear_velocity


func attach_rope(rope: Rope) -> void:
	attached_ropes.append(rope)

func detach_rope(rope: Rope) -> void:
	attached_ropes.erase(rope)

func get_attached_ropes() -> Array:
	return attached_ropes

func _on_GrappleArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("clicked", event.button_index == BUTTON_LEFT, self)
