extends Node2D


var room_scene = preload("res://Scenes/Environment/Room.tscn")

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

func entered_new_room(numPillar, numSmall, numBig, numExplosive, numRanged, numBomb):
	print(player.currentRoom.coords)
	visitedRooms.append(player.currentRoom)
	player.currentRoom.closeDoors()

	# Add a Pillar
	world.spawn_entity(Entities.PILLAR, randomEligibleRoomSpot())

	# Add some Enemies
	for i in range(10): world.spawn_entity(Entities.ENEMY_SMALL, randomEligibleRoomSpot())
	for i in range(3): world.spawn_entity(Entities.ENEMY_BIG, randomEligibleRoomSpot())
	for i in range(2): world.spawn_entity(Entities.ENEMY_EXPLOSIVE, randomEligibleRoomSpot())
	for i in range(3): world.spawn_entity(Entities.ENEMY_RANGED, randomEligibleRoomSpot())

	# Add some Bombs
	for i in range(2): world.spawn_entity(Entities.BOMB, randomEligibleRoomSpot())


func randomEligibleRoomSpot():
	return Vector2(rand_range(player.currentRoom.position[0] + 128, player.currentRoom.position[0] + 1280),
		rand_range(player.currentRoom.position[1] + 128, player.currentRoom.position[1] + 1280))


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
		world.ungrapple()

	elif event is InputEventKey:
		if event.scancode == KEY_R and event.is_pressed():
			get_tree().reload_current_scene()
		elif event.scancode == KEY_SPACE and event.is_pressed():
			world.attempt_rope_launch()
		elif event.scancode == KEY_ESCAPE and event.is_pressed():
			$CanvasLayer.add_child(load("res://Scenes/Menu/PauseMenu.tscn").instance())


func noCurrentRoom(coords):
	for room in createdRooms:
		if room.coords == coords:
			return false
	return true

func generateRoom(coords):
	var room = room_scene.instance()
	room.coords = coords
	room.position = Vector2(coords[0]*2880, coords[1]*2880)
	room.doorsOpened()
	world.add_child(room)
	#For unclear reasons, world.add_child resets room coords. Setting again.
	room.coords = coords
	createdRooms.append(room)
	return(room)

func getRoom(coords):
	var room = room_scene.instance()
	for r in createdRooms:
		if r.coords == coords:
			return(r)

func notAlreadyVisited(coords):
	for room in visitedRooms:
		if room.coords == coords:
			return false
	return true

func _process(delta):
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
			entered_new_room(2, 18, 4, 3, 3, 3)

func _on_World_room_cleared() -> void:
	player.currentRoom.roomCleared()
