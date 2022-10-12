extends RigidBody2D
class_name GrappleBody

var attached_ropes := []


func attach_rope(rope: Rope) -> void:
	attached_ropes.append(rope)

func detach_rope(rope: Rope) -> void:
	attached_ropes.erase(rope)

func get_attached_ropes() -> Array:
	return attached_ropes
