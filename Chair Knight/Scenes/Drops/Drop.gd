extends Area2D
class_name Drop

export(int) var value := 0
var target = null

const MAX_SPEED = 2000.0
const ACCELERATION = 7500.0
var velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	if target == null: return

	# Move towards target:
	var disp = target.global_position - global_position
	var desired_velocity = (disp * 10.0).clamped(MAX_SPEED)
	velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
	global_position += velocity * delta
	velocity *= 0.95

func set_target(target) -> void:
	self.target = target
