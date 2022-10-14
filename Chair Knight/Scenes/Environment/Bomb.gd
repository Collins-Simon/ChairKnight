extends GrappleBody
class_name Bomb


signal explode(exploder)


func explode():
	emit_signal("explode", self)
	emit_signal("destroyed", self)


func _on_Hurtbox_area_entered(area: Hitbox) -> void:
	var damage = area.receive_damage()
	if damage > 500: call_deferred("explode")


func _on_Bomb_body_entered(body: Node) -> void:
	var total_velocity := prev_velocity
	if body is GrappleBody:
		total_velocity -= body.prev_velocity

	var collision_speed = total_velocity.length()

	if collision_speed > 250:
		call_deferred("explode")
