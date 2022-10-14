extends Character
class_name Player


var rope_scene = preload("res://Scenes/Equipment/Rope.tscn")
var grapple_rope: Rope = null
var currentRoom = null
var coins := 0

onready var sprite = $Sprite
onready var hitbox = $Hitbox
onready var death_tween = $DeathTween


func _physics_process(delta: float) -> void:
	# Move the Player according to the current input:
	var input_vector := Vector2.ZERO
	if not destroyed:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move(input_vector, delta)

	# Make the damage of the Player's hitbox proportional its speed:
	hitbox.damage = linear_velocity.length()


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


func _on_Player_destroyed(body) -> void:
	$CollisionShape2D.disabled = true
	hitbox.monitorable = false
	$DropAttractionArea.monitoring = false
	$DropPickupArea.monitoring = false
	death_tween.interpolate_property(sprite, "material:shader_param/value", 1.0, 0.0, 1)
	death_tween.start()


func _on_DropAttractionArea_area_entered(area: Drop) -> void:
	area.set_target(self)


func _on_DropAttractionArea_area_exited(area: Drop) -> void:
	area.set_target(null)


func _on_DropPickupArea_area_entered(area: Drop) -> void:
	var value := area.value
	print(value)
	area.queue_free()
