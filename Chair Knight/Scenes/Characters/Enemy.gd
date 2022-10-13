extends GrappleTarget
class_name Enemy

var previous_pos: Vector2 = Vector2.ZERO

onready var sprite = $AnimatedSprite

func _on_Hurtbox_body_entered(body):
	if body is Player:
		#print(body.prev_velocity.length())
		if body.prev_velocity.length() > 1000:
			queue_free()
func _physics_process(delta):

	#print("x: %s" % get_position().x)
	#print("y: %s" % get_position().y)
	
	var current_velocity = get_position()- previous_pos
	previous_pos = get_position()
	print(current_velocity)
	if(current_velocity.x < 0):
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	

	
