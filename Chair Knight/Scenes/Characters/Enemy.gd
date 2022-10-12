extends GrappleTarget
class_name Enemy

var health := 1000

signal died(enemy)


func _on_Hurtbox_area_entered(area: Hitbox) -> void:
	var damage := min(area.damage, health)
	#print(damage)
	health -= damage
	if health <= 0:
		emit_signal("died", self)
