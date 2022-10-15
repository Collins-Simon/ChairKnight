extends Enemy
class_name EnemyBig


var charging_attack := false
var attacking := false

onready var playerDetectionZone = $PlayerDetectionZone
onready var attack_delay_timer = $AttackDelayTimer
onready var anim_player = $AnimationPlayer
onready var weapon_player = $WeaponAnimationPlayer
onready var particles = $Particles2D

var facing_right = true

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if playerDetectionZone.player_detected():
		var player_pos = playerDetectionZone.player.global_position
		direction = global_position.direction_to(player_pos)


		if(!(charging_attack or attacking)):
			if(direction.x > 0):
				facing_right = true
				$Sprite.flip_h = false
			else:
				facing_right = false
				$Sprite.flip_h = true


		if global_position.distance_to(player_pos) <= 400:
			if not charging_attack and not attacking:
				charging_attack = true
				attack_delay_timer.start()
				particles.process_material.direction = Vector3(direction.x, direction.y, 0.0)
				if(facing_right):weapon_player.play("Swing")
				else: weapon_player.play("Swing_Left")

		elif charging_attack and not attacking:
			charging_attack = false
			attack_delay_timer.stop()
			weapon_player.play("Idle")

	if attacking: move(Vector2.ZERO, delta)
	else: move(direction, delta)






func _on_AttackDelayTimer_timeout() -> void:
	charging_attack = false
	anim_player.play("Attack")
	attacking = true

func attack_finished() -> void:
	charging_attack = false
	attacking = false
	weapon_player.play("Idle")


