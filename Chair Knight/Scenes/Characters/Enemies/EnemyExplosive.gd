extends Enemy
class_name EnemyExplosive


var exploding = false

onready var playerDetectionZone = $PlayerDetectionZone
onready var anim_player = $AnimationPlayer

signal explode(exploder)


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if playerDetectionZone.player_detected():
		var player_pos = playerDetectionZone.player.global_position
		direction = global_position.direction_to(player_pos)

		if not exploding and global_position.distance_to(player_pos) <= 150:
			anim_player.play("Explode")
			exploding = true

	move(direction, delta)

func explode():
	emit_signal("explode", self)
	emit_signal("died", self)
