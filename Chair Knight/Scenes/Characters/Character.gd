extends GrappleBody
class_name Character

export(float) var max_speed = 5000
export(float) var acceleration = 2500
export(float) var idle_friction = 1000
export(float) var dampening_factor = 0.95
export(int) var health = 1000

signal died(enemy)


func _on_Hurtbox_area_entered(area: Hitbox) -> void:
	var max_damage = area.receive_damage()

	# Apply knockback:
	linear_velocity += area.global_position.direction_to(global_position) * max_damage

	# Apply damage:
	var damage := min(max_damage, health)
	health -= damage
	if health <= 0:
		emit_signal("died", self)


func move(direction: Vector2, delta: float) -> void:
	direction = direction.normalized()
	if direction:
		linear_velocity = linear_velocity.move_toward(direction * max_speed, delta * acceleration)
	else:
		linear_velocity = linear_velocity.move_toward(Vector2.ZERO, delta * idle_friction)
	linear_velocity *= dampening_factor