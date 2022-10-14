extends Node2D


var rope_scene = preload("res://Scenes/Equipment/Rope.tscn")
var pillar_scene = preload("res://Scenes/Environment/Pillar.tscn")
var bullet_scene = preload("res://Scenes/Equipment/Bullet.tscn")
var explosion_scene = preload("res://Scenes/Equipment/Explosion.tscn")
var bomb_scene = preload("res://Scenes/Environment/Bomb.tscn")

onready var player = $"%Player"
onready var entities = $"%Entities"
onready var ropes = $"%Ropes"
onready var map = $Map
onready var grapple_rope: Rope = null;


func _ready() -> void:
	# Add a Pillar
	entered_new_room(1, 10, 3, 2, 3, 2)

func entered_new_room(numPillar, numSmall, numBig, numExplosive, numRanged, numBomb):
	# Add a Pillar
	for i in range(numPillar):
		spawn_pillar()
	# Add some Enemies
	for i in range(numSmall):
		spawn_enemy(load("res://Scenes/Characters/Enemies/EnemySmall.tscn"))
	for i in range(numBig):
		spawn_enemy(load("res://Scenes/Characters/Enemies/EnemyBig.tscn"))
	for i in range(numExplosive):
		spawn_enemy(load("res://Scenes/Characters/Enemies/EnemyExplosive.tscn"))
	for i in range(numRanged):
		spawn_enemy(load("res://Scenes/Characters/Enemies/EnemyRanged.tscn"))
	# Add a couple of Bombs
	for i in range(2):
		spawn_bomb()

func randomEligibleRoomSpot():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return([rng.randf_range(map.position[0] + 128, map.position[0] + 1280), rng.randf_range(map.position[1] + 128, map.position[1] + 1280)])

func spawn_enemy(enemy_scene) -> void:
	var enemy = enemy_scene.instance()
	connect_grapple_body(enemy)
	if enemy is EnemyExplosive: enemy.connect("explode", self, "create_explosion")
	if enemy is EnemyRanged: enemy.connect("shoot_bullet", self, "shoot_bullet")
	var location = randomEligibleRoomSpot()
	enemy.position = Vector2(location[0], location[1])
	entities.add_child(enemy)

func spawn_bomb() -> void:
	var bomb = bomb_scene.instance()
	connect_grapple_body(bomb)
	bomb.connect("explode", self, "create_explosion")
	var location = randomEligibleRoomSpot()
	bomb.position = Vector2(location[0], location[1])
	entities.add_child(bomb)
	
func spawn_pillar() -> void:
	var pillar = pillar_scene.instance()
	connect_grapple_body(pillar)
	var location = randomEligibleRoomSpot()
	pillar.position = Vector2(location[0], location[1])
	entities.add_child(pillar)

func create_explosion(exploder: Node2D) -> void:
	var explosion: Explosion = explosion_scene.instance()
	explosion.global_position = exploder.global_position
	entities.add_child(explosion)

func shoot_bullet(shooter: Node2D, velocity: Vector2) -> void:
	var bullet: Bullet = bullet_scene.instance()
	bullet.init(shooter.global_position, velocity, shooter is Enemy)
	entities.add_child(bullet)

func connect_grapple_body(body: GrappleBody) -> void:
	body.connect("clicked", self, "_on_GrappleBody_clicked")
	body.connect("destroyed", self, "_on_GrappleBody_destroyed")

func _on_GrappleBody_destroyed(body: GrappleBody) -> void:
	var room_cleared = true
	for child in entities.get_children():
		if child is Enemy and child != body:
			room_cleared = false
			break
	if room_cleared: map.roomCleared()

	var attached_ropes := body.get_attached_ropes()
	for i in range(attached_ropes.size()-1, -1, -1):
		var rope: Rope = attached_ropes[i]
		if rope == grapple_rope: grapple_rope = null
		destroy_rope(rope)
	body.queue_free()

func _on_GrappleBody_clicked(left_click: bool, target: GrappleBody):
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
	destroy_rope(grapple_rope)
	grapple_rope = null

func destroy_rope(rope: Rope):
	rope.destroy()

func attempt_rope_launch():
	if grapple_rope == null: return
	var end_body = grapple_rope.end_body
	ungrapple()
	player.launch(end_body.global_position)
