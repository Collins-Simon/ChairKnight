extends Enemy
class_name EnemyBig


var charging_attack := false
var attacking := false

onready var playerDetectionZone = $PlayerDetectionZone
onready var attack_timer = $AttackTimer
onready var anim_player = $AnimationPlayer
onready var particles = $Particles2D


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if playerDetectionZone.player_detected():
		var player_pos = playerDetectionZone.player.global_position
		direction = global_position.direction_to(player_pos)
		particles.process_material.direction = Vector3(direction.x, direction.y, 0.0)

		if global_position.distance_to(player_pos) <= 400:
			if not charging_attack and not attacking:
				charging_attack = true
				attack_timer.start()

		elif charging_attack and not attacking:
			charging_attack = false
			attack_timer.stop()

	if attacking: move(Vector2.ZERO, delta)
	else: move(direction, delta)


func _on_AttackTimer_timeout() -> void:
	charging_attack = false
	anim_player.play("Attack")
	attacking = true

func attack_finished() -> void:
	charging_attack = false
	attacking = false
