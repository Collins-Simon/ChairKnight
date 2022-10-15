extends RigidBody2D
class_name GrappleBody
# GrappleBody represents a RigidBody2D that can be grappled by the Player.


var attached_ropes := [] # the list of Ropes currently attached to this GrappleBody
var prev_velocity := Vector2.ZERO
var destroyed := false

signal clicked(left_click, target)
signal destroyed(body)


func _physics_process(delta: float) -> void:
	# Save linear_velocity for use in collision damage calculations:
	prev_velocity = linear_velocity

# Adds to the attached_ropes list.
func attach_rope(rope: Rope) -> void:
	attached_ropes.append(rope)

# Removes from the attached_ropes list.
func detach_rope(rope: Rope) -> void:
	attached_ropes.erase(rope)

# Gets the list of attached ropes.
func get_attached_ropes() -> Array:
	return attached_ropes

# Notifies any listeners when this GrappleBody is left clicked.
# Used for grappling.
func _on_GrappleArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("clicked", event.button_index == BUTTON_LEFT, self)
