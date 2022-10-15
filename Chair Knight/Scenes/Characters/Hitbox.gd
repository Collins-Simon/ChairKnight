extends Area2D
class_name Hitbox
# Hitbox is an Area2D that collides with Hurtboxes in order to transfer damage
# from one entity to another.

export var damage: int = 0 # damage applied by this Hitbox

signal applied_damage(damage)


# Called by a Hurtbox to check how much damage to receive in a collision.
func receive_damage() -> int:
	emit_signal("applied_damage", damage)
	return damage
