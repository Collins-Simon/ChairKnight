extends GrappleBody
class_name Bomb
# Bomb is a GrappleBody that can be grappled and thrown by the Player.
# It creates an Explosion when it is in a fast enough collision.


signal explode(exploder)


# Emits signals that create an Explosion and destroy the Bomb.
func explode():
	emit_signal("explode", self)
	emit_signal("destroyed", self)

# Explodes if it receives enough damage from the Player.
func _on_Hurtbox_area_entered(area: Hitbox) -> void:
	var damage = area.receive_damage()
	if damage > 500: call_deferred("explode")

# Explodes if it is in a fast enough collision.
func _on_Bomb_body_entered(body: Node) -> void:
	var total_velocity := prev_velocity

	# If colliding with something that also has a velocity, add that to the total:
	if body is GrappleBody:
		total_velocity -= body.prev_velocity

	# Explode if fast enough:
	var collision_speed = total_velocity.length()
	if collision_speed > 250:
		call_deferred("explode")
