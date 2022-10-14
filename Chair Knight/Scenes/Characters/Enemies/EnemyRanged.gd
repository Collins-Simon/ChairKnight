extends Enemy
class_name EnemyRanged




onready var playerDetectionZone = $PlayerDetectionZone
onready var shoot_timer = $ShootTimer

var ready_to_shoot := true


onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")
onready var anim_player = $AnimationPlayer


signal shoot_bullet(shooter, velocity)
var direction



func _physics_process(delta: float) -> void:


	direction = Vector2.ZERO
	if playerDetectionZone.player_detected():
		direction = global_position.direction_to(playerDetectionZone.player.global_position)


		if ready_to_shoot:
			ready_to_shoot = false

			#Shooting triggered in the shoot animation
			animation_mode.travel("Shoot")
	else:
		animation_mode.travel("Idle")

	move(direction, delta)



	if(ready_to_shoot):
		if(direction.length() > 0):
			animation_mode.travel("Walk")
		else:
			animation_mode.travel("Idle")


	if(direction.x > 0):
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func _shoot() -> void:
	if(direction != Vector2.ZERO):
		emit_signal("shoot_bullet", self, direction.normalized() * 250)
	shoot_timer.start()
	animation_mode.travel("Walk")




func _on_ShootTimer_timeout() -> void:
	ready_to_shoot = true


