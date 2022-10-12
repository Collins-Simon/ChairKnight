extends RigidBody2D

class_name Player


export(float) var max_speed := 5000
var prev_velocity = Vector2.ZERO

signal attempted_peg(pos)


func _ready() -> void:
	self.gravity_scale = 0

func _physics_process(delta: float) -> void:

	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector:
		linear_velocity = linear_velocity.move_toward(input_vector * max_speed, delta * 2500)
	#else:
		#linear_velocity = linear_velocity.move_toward(Vector2.ZERO, delta * 300)
	linear_velocity *= 0.95
	prev_velocity = linear_velocity


func _on_PegArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.is_pressed():
		emit_signal("attempted_peg", get_global_mouse_position())

func launch(target_pos : Vector2):
	var diff := target_pos - global_position
	var dist := diff.length()
	apply_central_impulse(diff.normalized() * (3500 + dist * 5))
