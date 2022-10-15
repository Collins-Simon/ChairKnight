extends GrappleBody
class_name Character
# Character represents a GrappleBody that has health and can move by itself.


export(float) var max_speed = 5000.0
export(float) var acceleration = 2500.0
export(float) var idle_friction = 1000.0
export(float) var dampening_factor = 0.95
export(int) var health = 1000
var max_health = health

signal damaged(character, amount)
# warning-ignore:unused_signal
signal healed(character, amount)


func _ready():
	# Set max_health to health on initialisation:
	max_health = health


# Called when damaged by another entity.
# Could be a collision, attack, or explosion etc.
func _on_Hurtbox_area_entered(area: Hitbox) -> void:
	if destroyed: return # don't take damage if already destroyed
	var max_damage = area.receive_damage()

	# Apply knockback:
	linear_velocity += area.global_position.direction_to(global_position) * (250 + max_damage / 2.0)

	# Apply damage:
	var damage := min(max_damage, health)
	health -= damage
	emit_signal("damaged", self, damage)

	# If no health left:
	if health <= 0:
		destroyed = true
		emit_signal("destroyed", self)


# Moves the Character in a certain direction.
func move(direction: Vector2, delta: float) -> void:
	direction = direction.normalized()
	if direction: # if a direction is specified, accelerate toward it until max_speed is reached
		linear_velocity = linear_velocity.move_toward(direction * max_speed, delta * acceleration)
	else: # else just decrease the current velocity faster
		linear_velocity = linear_velocity.move_toward(Vector2.ZERO, delta * idle_friction)
	linear_velocity *= dampening_factor
