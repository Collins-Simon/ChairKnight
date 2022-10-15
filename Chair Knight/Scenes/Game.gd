extends Node2D


var room_scene = preload("res://Scenes/Environment/Room.tscn")
var player_dead := false

onready var player = $"%Player"
onready var entities = $"%Entities"
onready var ropes = $"%Ropes"
onready var world = $World
onready var createdRooms = []
onready var visitedRooms = []

func _ready() -> void:
	# Add a Pillar
	var start = generateRoom([0, 0])
	player.currentRoom = start
	player.currentRoom.coords = [0, 0]
	createdRooms.append(start)
	visitedRooms.append(start)
	entered_new_room(1, 10, 3, 2, 3, 2)

#Generates enemies, pillars, and bombs, at random locations across the current room, in desired numbers.
func entered_new_room(numPillar, numSmall, numBig, numExplosive, numRanged, numBomb):
	#print(player.currentRoom.coords)
	visitedRooms.append(player.currentRoom)
	player.currentRoom.closeDoors()

	# Add pillars
	for _i in range(numPillar): world.spawn_entity(Entities.PILLAR, randomEligibleRoomSpot())

	# Add some Enemies
	for _i in range(numSmall): world.spawn_entity(Entities.ENEMY_SMALL, randomEligibleRoomSpot())
	for _i in range(numBig): world.spawn_entity(Entities.ENEMY_BIG, randomEligibleRoomSpot())
	for _i in range(numExplosive): world.spawn_entity(Entities.ENEMY_EXPLOSIVE, randomEligibleRoomSpot())
	for _i in range(numRanged): world.spawn_entity(Entities.ENEMY_RANGED, randomEligibleRoomSpot())

	# Add some Bombs
	for _i in range(numBomb): world.spawn_entity(Entities.BOMB, randomEligibleRoomSpot())

#Return a random eligible location to place an entity at; if space occupied, run recursively until valid spot found.
func randomEligibleRoomSpot():
	var coords = Vector2(rand_range(player.currentRoom.position[0] + 128, player.currentRoom.position[0] + 1280),
		rand_range(player.currentRoom.position[1] + 128, player.currentRoom.position[1] + 1280))
	if(player.currentRoom.get_cell(int((coords[0]-player.currentRoom.position[0])/64), int((coords[1]-player.currentRoom.position[1])/64)) == 1):
		return(randomEligibleRoomSpot())
	return(coords)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
		player.ungrapple() # ungrapple when left mouse button is released

	elif event is InputEventKey:
		if event.scancode == KEY_BACKSPACE and event.is_pressed():
			var err = get_tree().reload_current_scene() # reload scene with BACKSPACE
			assert(err == OK)
		elif event.scancode == KEY_SPACE and event.is_pressed():
			player.grapple_launch()  # launch Player at grappled target with SPACE
		elif event.scancode == KEY_ESCAPE and event.is_pressed():
			$CanvasLayer.add_child(load("res://Scenes/Menu/PauseMenu.tscn").instance())
		elif event.scancode == KEY_E and event.is_pressed() and not player_dead:
			# Calculate arguments for Bomb being thrown by Player:
			var bomb_velocity: Vector2 = player.linear_velocity
			var bomb_direction : Vector2 = player.global_position.direction_to(get_global_mouse_position())
			bomb_velocity += bomb_direction * 500
			var bomb_pos = player.global_position + bomb_direction * 100
			var bomb_meta = {}
			bomb_meta["velocity"] = bomb_velocity
			world.spawn_entity(Entities.BOMB, bomb_pos, bomb_meta)

#Checks if a room has already been generated at specific coordinates.
func noCurrentRoom(coords):
	for room in createdRooms:
		if room.coords == coords:
			return false
	return true

#Creates a new room at the given coordinates.
func generateRoom(coords):
	var room = room_scene.instance()
	room.coords = coords
	room.addObstacles()
	room.position = Vector2(coords[0]*2880, coords[1]*2880)
	room.doorsOpened()
	world.add_child(room)
	#For unclear reasons, world.add_child resets room coords. Setting coords again.
	room.coords = coords
	createdRooms.append(room)
	return(room)

#Finds and returns the room with the given set of coordinates.
func getRoom(coords):
	var _room = room_scene.instance()
	for r in createdRooms:
		if r.coords == coords:
			return(r)

#Checks if player has already entered a given room.
func notAlreadyVisited(coords):
	for room in visitedRooms:
		if room.coords == coords:
			return false
	return true

#On each frame, check if a room needs to be generated or is being entered for the first time.
func _process(_delta):
	#Create new room if player to right of current room
	if(player.position[0] > player.currentRoom.position[0] + 2304):
		#Check no existing room to right
		if(noCurrentRoom([player.currentRoom.coords[0]+1, player.currentRoom.coords[1]])):
			var room = generateRoom([player.currentRoom.coords[0]+1, player.currentRoom.coords[1]])
			player.currentRoom = room
		else:
			player.currentRoom = getRoom([player.currentRoom.coords[0]+1, player.currentRoom.coords[1]])
	if(player.position[0] < player.currentRoom.position[0] - 960):
		#Check no existing room to left
		if(noCurrentRoom([player.currentRoom.coords[0]-1, player.currentRoom.coords[1]])):
			var room = generateRoom([player.currentRoom.coords[0]-1, player.currentRoom.coords[1]])
			player.currentRoom = room
		else:
			player.currentRoom = getRoom([player.currentRoom.coords[0]-1, player.currentRoom.coords[1]])
	if(player.position[1] > player.currentRoom.position[1] + 2304):
		#Check no existing room below current
		if(noCurrentRoom([player.currentRoom.coords[0], player.currentRoom.coords[1]+1])):
			var room = generateRoom([player.currentRoom.coords[0], player.currentRoom.coords[1]+1])
			player.currentRoom = room
		else:
			player.currentRoom = getRoom([player.currentRoom.coords[0], player.currentRoom.coords[1]+1])
	if(player.position[1] < player.currentRoom.position[1] - 960):
		#Check no existing room above current
		if(noCurrentRoom([player.currentRoom.coords[0], player.currentRoom.coords[1]-1])):
			var room = generateRoom([player.currentRoom.coords[0], player.currentRoom.coords[1]-1])
			player.currentRoom = room
		else:
			player.currentRoom = getRoom([player.currentRoom.coords[0], player.currentRoom.coords[1]-1])

	#print(player.currentRoom.position)
	#Alternatively, if room not visited and in confines:
	if(notAlreadyVisited(player.currentRoom.coords)):
		if(player.position[0] > player.currentRoom.position[0]+128 and player.position[0] < player.currentRoom.position[0]+1280 and player.position[1] > player.currentRoom.position[1]+128 and player.position[1] < player.currentRoom.position[1]+1280):
			entered_new_room(
				rand_range(0, 10) * Settings.difficulty_multiplier,	# numPillar
				rand_range(3, 30) * Settings.difficulty_multiplier,	# numSmall
				rand_range(1, 10) * Settings.difficulty_multiplier,	# numBig
				rand_range(1, 10) * Settings.difficulty_multiplier,	# numExplosive
				rand_range(1,10) * Settings.difficulty_multiplier,	# numRanged
				rand_range(1,10) * Settings.difficulty_multiplier	# numBomb
				)

func _on_World_room_cleared() -> void:
	player.currentRoom.roomCleared()


func _on_Player_destroyed(_body) -> void:
	player_dead = true
	yield(player.get_node("DeathTween"), "tween_all_completed")
	var death_screen = load("res://Scenes/Menu/DeathMenu.tscn").instance()
	death_screen.score = player.coins * Settings.difficulty_multiplier
	$CanvasLayer.add_child(death_screen)

