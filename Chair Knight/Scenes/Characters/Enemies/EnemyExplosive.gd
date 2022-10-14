extends Enemy
class_name EnemyExplosive


var exploding = false

onready var playerDetectionZone = $PlayerDetectionZone
onready var anim_player = $AnimationPlayer

onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")



signal explode(exploder)


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if playerDetectionZone.player_detected():
		var player_pos = playerDetectionZone.player.global_position
		direction = global_position.direction_to(player_pos)

		if not exploding and global_position.distance_to(player_pos) <= 150:
			anim_player.play("Explode")
			#animation_mode.travel("Explode")
			exploding = true

	move(direction, delta)
	#Animation handling
	if(direction.length() > 0):
		animation_mode.travel("Walk")
	else: animation_mode.travel("Idle")

	if(direction.x > 0):
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func explode():
	emit_signal("explode", self)
	emit_signal("died", self)
