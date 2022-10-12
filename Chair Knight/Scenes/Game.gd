extends Node2D


var rope_scene = preload("res://Scenes/Equipment/Rope.tscn")
var pillar_scene = preload("res://Scenes/Environment/Pillar.tscn")
var enemy_scene = preload("res://Scenes/Characters/Enemy.tscn")

onready var player = $"%Player"
onready var entities = $"%Entities"
onready var ropes = $"%Ropes"
onready var grapple_rope: Rope = null;


func _ready() -> void:
	# Add a Pillar
	var pillar: Pillar = pillar_scene.instance()
	pillar.connect("clicked", self, "_on_GrappleTarget_clicked")
	entities.add_child(pillar)

	# Add an Enemy
	var enemy: Enemy = enemy_scene.instance()
	enemy.connect("clicked", self, "_on_GrappleTarget_clicked")
	entities.add_child(enemy)


func _on_GrappleTarget_clicked(left_click: bool, target: GrappleTarget):
	if left_click:
		if grapple_rope != null: return
		grapple_rope = rope_scene.instance()
		grapple_rope.init(player, target)
		ropes.add_child(grapple_rope)

	else:
		if grapple_rope == null: return
		var end_body = grapple_rope.end_body
		if end_body == target: return
		if target.global_position.distance_squared_to(player.global_position) > 100_000: return
		ungrapple()

		var detached_rope = rope_scene.instance()
		detached_rope.init(target, end_body)
		ropes.add_child(detached_rope)

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
