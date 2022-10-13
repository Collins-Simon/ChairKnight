extends Enemy
class_name EnemyRanged


var ready_to_shoot := true

onready var playerDetectionZone = $PlayerDetectionZone
onready var shoot_timer = $ShootTimer

signal shoot_bullet(shooter, velocity)


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if playerDetectionZone.player_detected():
		direction = global_position.direction_to(playerDetectionZone.player.global_position)

		if ready_to_shoot:
			ready_to_shoot = false
			emit_signal("shoot_bullet", self, direction.normalized() * 250)
			shoot_timer.start()

	move(direction, delta)


func _on_ShootTimer_timeout() -> void:
	ready_to_shoot = true
