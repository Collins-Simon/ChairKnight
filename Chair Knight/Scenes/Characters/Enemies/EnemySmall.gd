extends Enemy
class_name EnemySmall


var charging_attack := false
var attacking := false

onready var playerDetectionZone = $PlayerDetectionZone
onready var attack_delay_timer = $AttackDelayTimer
onready var anim_player = $AnimationPlayer
onready var particles = $Particles2D


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if playerDetectionZone.player_detected():
		var player_pos = playerDetectionZone.player.global_position
		direction = global_position.direction_to(player_pos)
		particles.process_material.direction = Vector3(direction.x, direction.y, 0.0)

		if global_position.distance_to(player_pos) <= 100:
			if not charging_attack and not attacking:
				charging_attack = true
				attack_delay_timer.start()

		elif charging_attack and not attacking:
			charging_attack = false
			attack_delay_timer.stop()

	if attacking: move(Vector2.ZERO, delta)
	else: move(direction, delta)


func _on_AttackDelayTimer_timeout() -> void:
	charging_attack = false
	anim_player.play("Attack")
	attacking = true

func attack_finished() -> void:
	charging_attack = false
	attacking = false
