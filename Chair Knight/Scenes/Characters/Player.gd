extends Character
class_name Player


onready var hitbox = $Hitbox
onready var currentRoom = null
onready var anim_sprite = $AnimatedSprite
var diving = false;

func _on_AnimatedSprite_animation_finished():
	if(anim_sprite.get_animation() == "Dive"):
		diving = false
		anim_sprite.set_animation("Walk")



func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move(input_vector, delta)
	hitbox.damage = linear_velocity.length()
	
	#Handle animations
	if(linear_velocity.x > 0):
		anim_sprite.flip_h = false
	else:
		anim_sprite.flip_h = true
	

func launch(target_pos : Vector2) -> void:
	anim_sprite.set_animation("Dive")
	diving = true
	var diff := target_pos - global_position
	var dist := diff.length()
	apply_central_impulse(diff.normalized() * (3500 + dist * 5))
