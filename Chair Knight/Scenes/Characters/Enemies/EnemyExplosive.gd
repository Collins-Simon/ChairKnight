extends Enemy
class_name EnemyExplosive
# EnemyExplosive is an Enemy that glows red before exploding when the Player is
# too close (think of a creeper from Minecraft).


var exploding = false

onready var playerDetectionZone = $PlayerDetectionZone
onready var anim_player = $AnimationPlayer
onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")

signal explode(exploder)


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO

	# If the Player is detected:
	if playerDetectionZone.player_detected():
		var player_pos = playerDetectionZone.player.global_position
		direction = global_position.direction_to(player_pos)

		# If the Player is close enough to be attacked, start the exploding sequence:
		if not exploding and global_position.distance_to(player_pos) <= 150:
			anim_player.play("Explode")
			exploding = true

	move(direction, delta) # move toward the Player if detected

	# Animation handling:
	if(direction.length() > 0):
		animation_mode.travel("Walk")
	else: animation_mode.travel("Idle")

	# Face the direction of movement:
	if(direction.x > 0):
		$Sprite.flip_h = false
	elif (direction.x < 0):
		$Sprite.flip_h = true

# Emits signals to create an Explosion and destroy this EnemyExplosive.
func explode():
	emit_signal("explode", self)
	emit_signal("destroyed", self)
