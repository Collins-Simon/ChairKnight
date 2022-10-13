extends Area2D
class_name Hitbox


export var damage: int = 0

signal applied_damage(damage)


func receive_damage() -> int:
	emit_signal("applied_damage", damage)
	return damage
