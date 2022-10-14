extends Character
class_name Player


var rope_scene = preload("res://Scenes/Equipment/Rope.tscn")
var grapple_rope: Rope = null

onready var hitbox = $Hitbox
onready var currentRoom = null

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move(input_vector, delta)
	hitbox.damage = linear_velocity.length()


func grapple(target: GrappleBody) -> void:
	grapple_rope = rope_scene.instance()
	grapple_rope.init(self, target)

func is_grappled() -> bool:
	return grapple_rope != null

func ungrapple() -> void:
	if grapple_rope == null: return
	grapple_rope.destroy()
	grapple_rope = null

func grapple_launch() -> void:
	if grapple_rope == null: return
	var end_body = grapple_rope.end_body
	ungrapple()
	launch(end_body.global_position)


func launch(target_pos : Vector2) -> void:
	var diff := target_pos - global_position
	var dist := diff.length()
	apply_central_impulse(diff.normalized() * (3500 + dist * 5))
