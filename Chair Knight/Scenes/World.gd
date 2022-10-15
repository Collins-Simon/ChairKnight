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
			entity.connect("damaged", self, "_on_Character_damaged")
			if entity is EnemyExplosive: entity.connect("explode", self, "create_explosion")
			elif entity is EnemyRanged: entity.connect("shoot_bullet", self, "shoot_bullet")

		elif entity is Bomb:
			entity.connect("explode", self, "create_explosion")

	elif entity is Drop:
		if meta_data.has("velocity"): entity.init(pos, meta_data.get("velocity"))
		else: entity.init(pos)

	elif entity is FloatingText:
		entity.init(meta_data.get("text"), meta_data.get("color"))

	# Finally add it to the scene:
	entities.call_deferred("add_child", entity)


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


# Spawns a FloatingText with the damage amount whenever a Character is damaged.
func _on_Character_damaged(character: Character, amount: int) -> void:
	var pos = character.global_position + Vector2(10, -30)
	var meta_data := {}
	meta_data["text"] = "-" + str(amount)
	if character is Player: meta_data["color"] = Color(1, 0.1, 0) # red
	else: meta_data["color"] = Color(0.8, 0.8, 0) # yellow
	spawn_entity(Entities.FLOATING_TEXT, pos, meta_data)

# Spawns a FloatingText with the heal amount whenever a Character is healed.
func _on_Character_healed(character: Character, amount: int) -> void:
	var pos = character.global_position + Vector2(10, -30)
	var meta_data := {}
	meta_data["text"] = "+" + str(amount)
	meta_data["color"] = Color(0, 0.9, 0) # green
	spawn_entity(Entities.FLOATING_TEXT, pos, meta_data)

# Connects the GrappleBody's signals to the right methods.
func connect_grapple_body(body: GrappleBody) -> void:
# warning-ignore:return_value_discarded
	body.connect("clicked", self, "_on_GrappleBody_clicked")
# warning-ignore:return_value_discarded
	body.connect("destroyed", self, "_on_GrappleBody_destroyed")

# Called when a GrappleBody is clicked.
func _on_GrappleBody_clicked(left_click: bool, target: GrappleBody):
	# If left clicked, let the Player grapple to the target.
	if left_click:
		if player.is_grappled() or player.destroyed: return
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
	# If Enemy died, drop Health and Coins:
	if body is Enemy:
		var pos = body.global_position
		var num_health_drops: int = int(ceil(body.dropped_health / 100.0))
		var num_coin_drops: int = body.dropped_coins
		for _i in range(num_health_drops):
			spawn_entity(Entities.HEALTH, pos)
		for _i in range(num_coin_drops):
			spawn_entity(Entities.COIN, pos)

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




