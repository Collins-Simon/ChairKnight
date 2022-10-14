extends Node2D


var rope_scene = preload("res://Scenes/Equipment/Rope.tscn")
var bullet_scene = preload("res://Scenes/Equipment/Bullet.tscn")
var explosion_scene = preload("res://Scenes/Equipment/Explosion.tscn")

onready var player: Player = $"%Player"
onready var entities = $"%Entities"
onready var ropes = $"%Ropes"

signal room_cleared


# Spawns an entity defined by the given enum at the specified position.
func spawn_entity(entity_enum: int, pos: Vector2 = Vector2.INF, meta_data: Dictionary = {}) -> void:
	# Create the entity:
	var entity = Entities.get_scene(entity_enum).instance()

	# Set its position:
	if pos == Vector2.INF:
		pos = Vector2(rand_range(-100, 100), rand_range(-100, 100))
	entity.global_position = pos

	# Connect its signals:
	if entity is GrappleBody:
		connect_grapple_body(entity)
		if meta_data.has("velocity"): entity.linear_velocity = meta_data.get("velocity")

		if entity is Enemy:
			if entity is EnemyExplosive: entity.connect("explode", self, "create_explosion")
			elif entity is EnemyRanged: entity.connect("shoot_bullet", self, "shoot_bullet")

		elif entity is Bomb:
			entity.connect("explode", self, "create_explosion")

	# Finally add it to the scene:
	entities.add_child(entity)


# Creates an Explosion at the position of the given exploder.
func create_explosion(exploder: Node2D) -> void:
	var explosion: Explosion = explosion_scene.instance()
	explosion.global_position = exploder.global_position
	entities.add_child(explosion)


# Creates a Bullet at the position of the shooter with the given velocity.
func shoot_bullet(shooter: Node2D, velocity: Vector2) -> void:
	var bullet: Bullet = bullet_scene.instance()
	bullet.init(shooter.global_position, velocity, shooter is Enemy)
	entities.add_child(bullet)


# Connects the GrappleBody's signals to the right methods.
func connect_grapple_body(body: GrappleBody) -> void:
	body.connect("clicked", self, "_on_GrappleBody_clicked")
	body.connect("destroyed", self, "_on_GrappleBody_destroyed")

# Called when a GrappleBody is clicked.
func _on_GrappleBody_clicked(left_click: bool, target: GrappleBody):
	# If left clicked, let the Player grapple to the target.
	if left_click:
		if player.is_grappled(): return
		player.grapple(target)
		ropes.add_child(player.grapple_rope)

	# Else if right clicked, tie the target to the currently grappled entity.
	else:
		if not player.is_grappled(): return
		var end_body = player.grapple_rope.end_body
		if end_body == target: return
		if target.global_position.distance_to(player.global_position) > 300: return
		player.ungrapple()
		var detached_rope = rope_scene.instance()
		detached_rope.init(target, end_body)
		ropes.add_child(detached_rope)

# Called when a GrappleBody should be destroyed.
func _on_GrappleBody_destroyed(body: GrappleBody) -> void:
	# Check if there are any Enemies left:
	var room_cleared = true
	for child in entities.get_children():
		if child is Enemy and child != body:
			room_cleared = false
			break
	if room_cleared: emit_signal("room_cleared")

	# Delete all ropes attached to the entity before destroying it:
	var attached_ropes := body.get_attached_ropes()
	for i in range(attached_ropes.size()-1, -1, -1):
		var rope: Rope = attached_ropes[i]
		if rope == player.grapple_rope: player.ungrapple()
		else: rope.destroy()

	# Finally delete the entity:
	body.queue_free()

