extends Character
class_name Player


var rope_scene = preload("res://Scenes/Equipment/Rope.tscn")
var grapple_rope: Rope = null
var currentRoom = null
var coins := 0

onready var hitbox = $Hitbox
onready var death_tween = $DeathTween
onready var anim_sprite = $AnimatedSprite
var diving = false
var damaged = false

func _on_AnimatedSprite_animation_finished():
	if(anim_sprite.get_animation() == "Dive"):
		diving = false
		anim_sprite.set_animation("Walk")
	if(anim_sprite.get_animation() == "Damaged"):
		damaged	= false
		anim_sprite.modulate = Color(1,1,1)
		anim_sprite.set_animation("Walk")
		


func _physics_process(delta: float) -> void:
	# Move the Player according to the current input:
	var input_vector := Vector2.ZERO
	if not destroyed:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move(input_vector, delta)

	# Make the damage of the Player's hitbox proportional its speed:
	hitbox.damage = linear_velocity.length()

	#Handle animations
	#Set orientation

	if(linear_velocity.x > 5):
		anim_sprite.flip_h = false
	elif(linear_velocity.x < -5):
		anim_sprite.flip_h = true
	elif(linear_velocity.length() < 5 and !diving and !damaged):
		anim_sprite.set_animation("Idle")
		anim_sprite.modulate = Color(1,1,1)

	if(linear_velocity.length() > 5 and !diving and !damaged):
		anim_sprite.set_animation("Walk")
		anim_sprite.modulate = Color(1,1,1)


func _on_Player_damaged(amount):
	damaged = true
	anim_sprite.set_animation("Damaged")

	
	#anim_sprite.modulate = "0.945098,0.219608,0.219608,1"
	anim_sprite.modulate = Color(0.945098,0.219608,0.219608)

	pass # Replace with function body.


# Grapple a given target.
func grapple(target: GrappleBody) -> void:
	grapple_rope = rope_scene.instance()
	grapple_rope.init(self, target)

# Check if the Player is grappled.
func is_grappled() -> bool:
	return grapple_rope != null

# Ungrapple if currently grappled.
func ungrapple() -> void:
	if grapple_rope == null: return
	grapple_rope.destroy()
	grapple_rope = null

# Attempt to launch the Player at the grappled target.
func grapple_launch() -> void:
	if grapple_rope == null: return
	var end_body = grapple_rope.end_body
	ungrapple()
	launch(end_body.global_position)



# Launches the Player at a given position.
func launch(target_pos : Vector2) -> void:
	var diff := target_pos - global_position
	var dist := diff.length()
	apply_central_impulse(diff.normalized() * (3500 + dist * 5))
	anim_sprite.set_animation("Dive")
	diving = true
	damaged = false


func _on_Player_destroyed(body) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	hitbox.set_deferred("monitorable", false)
	$DropAttractionArea.monitoring = false
	$DropPickupArea.monitoring = false
	death_tween.interpolate_property(anim_sprite, "material:shader_param/glow", 0.0, 1.0, 0.5, Tween.TRANS_BOUNCE)
	death_tween.interpolate_property(anim_sprite, "material:shader_param/shrink", 0.0, 1.0, 1.0)
	death_tween.start()


func _on_DropAttractionArea_area_entered(area: Drop) -> void:
	area.set_target(self)


func _on_DropAttractionArea_area_exited(area: Drop) -> void:
	area.set_target(null)


func _on_DropPickupArea_area_entered(area: Drop) -> void:
	var value := area.value
	if area is Health:
		health += min(value, max_health - health)
	elif area is Coin:
		coins += value
		print("picked up coin. total: ", coins)
	area.queue_free()


