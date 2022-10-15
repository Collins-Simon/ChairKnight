extends Enemy
class_name EnemyRanged
# EnemyRanged is a slow Enemy that shoots Bullets at the Player.


var ready_to_shoot := true
var direction

onready var playerDetectionZone = $PlayerDetectionZone
onready var shoot_timer = $ShootTimer
onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")
onready var anim_player = $AnimationPlayer

signal shoot_bullet(shooter, velocity)


func _physics_process(delta: float) -> void:
	direction = Vector2.ZERO

	# If the Player is detected:
	if playerDetectionZone.player_detected():
		direction = global_position.direction_to(playerDetectionZone.player.global_position)

		# If ready to shoot, play the shooting animation:
		if ready_to_shoot:
			ready_to_shoot = false
			# Shooting is triggered in the shoot animation
			animation_mode.travel("Shoot")

	# If the Player is not detected, play the idle animation:
	else:
		animation_mode.travel("Idle")

	move(direction, delta) # move toward the Player if detected

	# Animation handling:
	if(ready_to_shoot):
		if(direction.length() > 0):
			animation_mode.travel("Walk")
		else:
			animation_mode.travel("Idle")

	# Face the direction of movement:
	if(direction.x > 0):
		$Sprite.flip_h = false
	elif (direction.x < 0):
		$Sprite.flip_h = true


# Emits a signal to shoot a Bullet, and starts the walking animation:
func _shoot() -> void:
	if(direction != Vector2.ZERO):
		emit_signal("shoot_bullet", self, direction.normalized() * 250)
	shoot_timer.start()
	animation_mode.travel("Walk")

# Signals that the EnemyRanged is ready to shoot again:
func _on_ShootTimer_timeout() -> void:
	ready_to_shoot = true


