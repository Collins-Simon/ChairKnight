extends Enemy
class_name EnemyBig
# EnemyBig is a big, slow Enemy with lots of health that deals plenty of damage
# via a slow melee attack.


var charging_attack := false
var attacking := false
var facing_right = true

onready var playerDetectionZone = $PlayerDetectionZone
onready var attack_delay_timer = $AttackDelayTimer
onready var anim_player = $AnimationPlayer
onready var weapon_player = $WeaponAnimationPlayer
onready var particles = $Particles2D


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO

	# If the Player is detected:
	if playerDetectionZone.player_detected():
		var player_pos = playerDetectionZone.player.global_position
		direction = global_position.direction_to(player_pos)

		# If not attacking, face the movement direction:
		if(!(charging_attack or attacking)):
			if(direction.x > 0):
				facing_right = true
				$Sprite.flip_h = false
			else:
				facing_right = false
				$Sprite.flip_h = true

		# If the Player is close enough, attack them:
		if global_position.distance_to(player_pos) <= 400:
			if not charging_attack and not attacking:
				charging_attack = true
				attack_delay_timer.start()
				# Set the attack particles direction:
				particles.process_material.direction = Vector3(direction.x, direction.y, 0.0)
				if(facing_right):weapon_player.play("Swing")
				else: weapon_player.play("Swing_Left")

		# Else if the Player is out of reach, reset the attack delay:
		elif charging_attack and not attacking:
			charging_attack = false
			attack_delay_timer.stop()
			weapon_player.play("Idle")

	# Stay still if attacking, else move towards the Player if detected:
	if attacking: move(Vector2.ZERO, delta)
	else: move(direction, delta)


# Play the attack animation after the attack delay is done.
func _on_AttackDelayTimer_timeout() -> void:
	charging_attack = false
	anim_player.play("Attack")
	attacking = true

# Play the idle weapon animation after the attack is finished.
func attack_finished() -> void:
	charging_attack = false
	attacking = false
	weapon_player.play("Idle")


