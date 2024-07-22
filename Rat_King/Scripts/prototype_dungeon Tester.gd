extends Node2D

var dungeon = {}
#var node_sprite = load("res://map_nodes1.png")
#var branch_sprite = load("res://map_nodes3.png")

@onready var map_node = $MapNode
@onready var dungeon_generation = $"Dungeon Generator"

func _ready():
	dungeon = dungeon_generation.generate(0)
	load_map()

func load_map():
	#Removes previously generated dungeons
	for i in range(0, map_node.get_child_count()):
		map_node.get_child(i).queue_free()
	
	print("Generating new map")
	
	print("Starting Room at (0, 0)")
	#Spawn Start Room
	var startRoom = dungeon[Vector2.ZERO]
	map_node.add_child(startRoom)
	startRoom.z_index = 1
	startRoom.position = Vector2.ZERO
	
	#It will never try to connect to something that hasnt spawned yet
	#So we jsut need to spawn a new room and then find its connections
	#If one of its connections hasnt spawned in yet, then we ignore it
	
	while map_node.get_child_count(false) < dungeon.size():
		for i in dungeon.keys():
			if i == Vector2.ZERO:
				continue
			var newRoom = dungeon[i]
			#Step one, find the direction this room was spawned in 
			#We know the spawn direction in a variable on the new room
			var direction: Vector2 = newRoom.spawnedDirection
			#Now that we know the direction, lets find out what room its connected to in the opposite direction
			#New Dungeon Room Position + Direction = Connected Room
			
			print("Spawning New Room")
			
			print("NewRoom at: " + str(i))
			print("Direction: " + str(direction))
			print("Connected Room at: " + str(i - direction))
			
			var connectedRoom = dungeon[i - direction]
			#Now we have the 2 rooms, lets connect the appropriate entrances. connectedRoom is in the correct position
			var distance = get_distance_between_rooms(newRoom, connectedRoom, direction)
			#Set new room position with distance
			newRoom.position = connectedRoom.position + (direction * distance)
			map_node.add_child(newRoom)
			newRoom.z_index = 1

func get_distance_between_rooms(newRoom, connectedRoom, direction: Vector2):
	var distance = 0
	#Connected Room
	var connectedRoomDistanceToDoor: float
	#East
	if direction == Vector2(1,0):
		connectedRoomDistanceToDoor = connectedRoom.global_position.distance_to(connectedRoom.eastDoor.global_position)
	#West
	if direction == Vector2(-1,0):
		connectedRoomDistanceToDoor = connectedRoom.global_position.distance_to(connectedRoom.westDoor.global_position)
	#North
	if direction == Vector2(0,1):
		connectedRoomDistanceToDoor = connectedRoom.global_position.distance_to(connectedRoom.northDoor.global_position)
	#South
	if direction == Vector2(0,-1):
		connectedRoomDistanceToDoor = connectedRoom.global_position.distance_to(connectedRoom.southDoor.global_position)
	
	#New Room
	var newRoomDistanceToDoor: float
	#East
	if -direction == Vector2(1,0):
		newRoomDistanceToDoor = newRoom.global_position.distance_to(newRoom.eastDoor.global_position)
	#West
	if -direction == Vector2(-1,0):
		newRoomDistanceToDoor = newRoom.global_position.distance_to(newRoom.westDoor.global_position)
	#North
	if -direction == Vector2(0,1):
		newRoomDistanceToDoor = newRoom.global_position.distance_to(newRoom.northDoor.global_position)
	#South
	if -direction == Vector2(0,-1):
		newRoomDistanceToDoor = newRoom.global_position.distance_to(newRoom.southDoor.global_position)
	
	#Now add up to full distance in absolute value
	distance = newRoomDistanceToDoor + connectedRoomDistanceToDoor + 1
	
	return distance

func _on_button_pressed():
	randomize()
	dungeon = dungeon_generation.generate(randi_range(-1000, 1000))
	load_map()
