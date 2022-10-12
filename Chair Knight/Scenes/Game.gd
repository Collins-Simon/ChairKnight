extends Node2D


var rope_scene = preload("res://Scenes/Equipment/Rope.tscn")
var peg_scene = preload("res://Scenes/Equipment/Peg.tscn")

onready var player = $"%Player"
onready var entities = $"%Entities"
onready var ropes = $"%Ropes"
onready var grapple_rope: Rope = null;


func _on_GrappleTarget_clicked(target):
	if grapple_rope != null: return
	grapple_rope = rope_scene.instance()
	grapple_rope.init(player, target)
	ropes.add_child(grapple_rope)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
		ungrapple()

	elif event is InputEventKey:
		if event.scancode == KEY_R and event.is_pressed():
			get_tree().reload_current_scene()
		elif event.scancode == KEY_SPACE and event.is_pressed():
			attempt_rope_launch()

func ungrapple():
	if grapple_rope == null: return
	ropes.remove_child(grapple_rope)
	grapple_rope.queue_free()
	grapple_rope = null

func attempt_rope_launch():
	if grapple_rope == null: return
	var end_body = grapple_rope.end_body
	ungrapple()
	player.launch(end_body.global_position)


func _on_Player_attempted_peg(pos):
	if grapple_rope == null: return
	var end_body = grapple_rope.end_body
	ungrapple()

	var peg = peg_scene.instance()
	peg.global_position = pos;
	entities.add_child(peg)

	var detached_rope = rope_scene.instance()
	detached_rope.init(peg, end_body)
	ropes.add_child(detached_rope)
