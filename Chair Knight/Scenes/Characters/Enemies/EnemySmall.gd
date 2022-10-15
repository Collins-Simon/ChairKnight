extends Enemy
class_name EnemySmall
# EnemySmall is a small, quick Enemy with low health that deals little damage
# via a quick melee attack.


var charging_attack := false
var attacking := false

onready var playerDetectionZone = $PlayerDetectionZone
onready var attack_delay_timer = $AttackDelayTimer
onready var anim_player = $AnimationPlayer
onready var particles = $Particles2D
onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO

	# If the Player is detected:
	if playerDetectionZone.player_detected():
		var player_pos = playerDetectionZone.player.global_position
		direction = global_position.direction_to(player_pos)
		# Set the attack particles direction:
		particles.process_material.direction = Vector3(direction.x, direction.y, 0.0)

		# If the Player is close enough to attack:
		if global_position.distance_to(player_pos) <= 100:
			if not charging_attack and not attacking:
				charging_attack = true
				attack_delay_timer.start()

		# Else if the Player is too far, reset the attack delay:
		elif charging_attack and not attacking:
			charging_attack = false
			attack_delay_timer.stop()

	# Stay still if attacking, else move towards the Player if detected
	if attacking: move(Vector2.ZERO, delta)
	else: move(direction, delta)

	#Animation handling:
	if(direction.length() > 0):
		animation_mode.travel("Walk")
	else: animation_mode.travel("Idle")

	# Face the direction of movement:
	if(direction.x > 0):
		$Sprite.flip_h = false
	elif (direction.x < 0):
		$Sprite.flip_h = true

# Play attack animation when the attack delay is over.
func _on_AttackDelayTimer_timeout() -> void:
	charging_attack = false
	animation_mode.start("Attack")
	attacking = true

# Called when the attack is finished.
func attack_finished() -> void:
	charging_attack = false
	attacking = false

