extends Enemy
class_name EnemyExplosive


onready var playerDetectionZone = $PlayerDetectionZone


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if playerDetectionZone.player_detected():
		direction = global_position.direction_to(playerDetectionZone.player.global_position)

	move(direction, delta)
