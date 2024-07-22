extends Node2D

#Generation Variables
@export var dungeon_type: PackedScene
var possible_rooms: Array[PackedScene]

@export var min_number_rooms: int = 6
@export var max_number_of_rooms: int = 10

var generation_chance = 20 #percent chance for room to spawn

#Dungeon Loading Variables
var dungeon = {} #A dictionary of all the rooms. No longer needs to store them based on Vector2's
@onready var map_node = $MapNode

func _ready():
	randomize()
	dungeon = generate_dungeon(randi_range(-1000, 1000))

func generate_dungeon(room_seed):
	#Removes previously generated dungeons
	for i in range(0, map_node.get_child_count()):
		map_node.get_child(i).queue_free()
	
	seed(room_seed)
	var newDungeon = {}
	var size = floor(randi_range(min_number_rooms, max_number_of_rooms))
	
	#Instantiate the selection of rooms. Delete later
	var room_holder_in_run = dungeon_type.instantiate()
	possible_rooms = room_holder_in_run.rooms
	
	#Spawn Start Room
	newDungeon[0] = possible_rooms[0].instantiate()
	newDungeon[0].position = Vector2.ZERO
	newDungeon[0].z_index = 1
	map_node.add_child(newDungeon[0])
	size -= 1
	
	#Loop through and spawn rooms
	while(size > 0):
		for i in newDungeon.keys():
			#Check Generation Chance to see if a room spawns off of this room
			if(randi_range(0,100) < generation_chance) and size > 0:
				#Get New Room Direction
				var direction = randi_range(0,4)
				
				#East
				if direction < 1 and newDungeon[i].eastDoor != null and newDungeon[i].connected_rooms["East"] == null:
					#Pick room type. New room must have a WEST entrance
					var roomType = randi_range(0, possible_rooms.size()-1)
					var newRoom = possible_rooms[roomType].instantiate()
					while newRoom.westDoor == null:
						newRoom.queue_free()
						roomType = randi_range(0, possible_rooms.size()-1)
						newRoom = possible_rooms[roomType].instantiate()
					#New room has a west entrance now!
					#position new room
					var pos = calculate_new_room_position(newRoom, newRoom.westDoor, newDungeon[i], newDungeon[i].eastDoor, Vector2.RIGHT)
					newRoom.global_position = pos
					newRoom.z_index = 1
					
					#Time for a collision test! Every room needs an area collider on collision layer 16
					if newRoom.check_area():
						#There is a room in the way
						newRoom.queue_free()
					else:
						map_node.add_child(newRoom)
						newDungeon[newDungeon.size()] = newRoom
						size -= 1
						connect_rooms(newDungeon[i], newRoom, "East", "West")
				
				#West
				elif direction < 2 and newDungeon[i].westDoor != null and newDungeon[i].connected_rooms["West"] == null:
					#Pick room type. New room must have an EAST entrance
					var roomType = randi_range(0, possible_rooms.size()-1)
					var newRoom = possible_rooms[roomType].instantiate()
					while newRoom.eastDoor == null:
						newRoom.queue_free()
						roomType = randi_range(0, possible_rooms.size()-1)
						newRoom = possible_rooms[roomType].instantiate()
					#New room has an east entrance now!
					#position new room
					var pos = calculate_new_room_position(newRoom, newRoom.eastDoor, newDungeon[i], newDungeon[i].westDoor, Vector2.LEFT)
					newRoom.position = pos
					newRoom.z_index = 1
					
					#Time for a collision test! Every room needs an area collider on collision layer 16
					if newRoom.check_area() == true:
						#There is a room in the way
						newRoom.queue_free()
					else:
						map_node.add_child(newRoom)
						newDungeon[newDungeon.size()] = newRoom
						size -= 1
						connect_rooms(newDungeon[i], newRoom, "West", "East")
				
				#North
				elif direction < 3 and newDungeon[i].northDoor != null and newDungeon[i].connected_rooms["North"] == null:
					#Pick room type. New room must have a SOUTH entrance
					var roomType = randi_range(0, possible_rooms.size()-1)
					var newRoom = possible_rooms[roomType].instantiate()
					while newRoom.southDoor == null:
						newRoom.queue_free()
						roomType = randi_range(0, possible_rooms.size()-1)
						newRoom = possible_rooms[roomType].instantiate()
					#New room has a south entrance now!
					#position new room
					var pos = calculate_new_room_position(newRoom, newRoom.southDoor, newDungeon[i], newDungeon[i].northDoor, Vector2.UP)
					newRoom.position = pos
					newRoom.z_index = 1
					
					#Time for a collision test! Every room needs an area collider on collision layer 16
					if newRoom.check_area() == true:
						#There is a room in the way
						newRoom.queue_free()
					else:
						map_node.add_child(newRoom)
						newDungeon[newDungeon.size()] = newRoom
						size -= 1
						connect_rooms(newDungeon[i], newRoom, "North", "South")
				
				#South
				elif direction < 4 and newDungeon[i].southDoor != null and newDungeon[i].connected_rooms["South"] == null:
					#Pick room type. New room must have a NORTH entrance
					var roomType = randi_range(0, possible_rooms.size()-1)
					var newRoom = possible_rooms[roomType].instantiate()
					while newRoom.northDoor == null:
						newRoom.queue_free()
						roomType = randi_range(0, possible_rooms.size()-1)
						newRoom = possible_rooms[roomType].instantiate()
					#New room has a north entrance now!
					#position new room
					var pos = calculate_new_room_position(newRoom, newRoom.northDoor, newDungeon[i], newDungeon[i].southDoor, Vector2.DOWN)
					newRoom.position = pos
					newRoom.z_index = 1
					
					#Time for a collision test! Every room needs an area collider on collision layer 16
					if newRoom.check_area() == true:
						#There is a room in the way
						newRoom.queue_free()
					else:
						map_node.add_child(newRoom)
						newDungeon[newDungeon.size()] = newRoom
						size -= 1
						connect_rooms(newDungeon[i], newRoom, "South", "North")
	return newDungeon

func connect_rooms(oldRoom, newRoom, newDirection: String, oppositeDirection: String):
	print("Direction Previously Occupied" + str(oldRoom.connected_rooms[newDirection]))
	oldRoom.connected_rooms[newDirection] = newRoom
	newRoom.connected_rooms[oppositeDirection] = oldRoom
	oldRoom.number_of_connections += 1
	newRoom.number_of_connections += 1
	print("Direction: " + newDirection + " Node: " + str(oldRoom.connected_rooms[newDirection]))

func calculate_new_room_position(newRoom, newRoomDoor, connectedRoom, connectedRoomDoor, direction):
	#Get the offset between the new rooms position and the appropriate door
	var newDistance: float = newRoom.global_position.distance_to(newRoomDoor.global_position)
	var newRoomDirection = newRoomDoor.global_position.direction_to(newRoom.global_position).normalized()
	
	#Do the same for the connected room
	var connectedDistance: float = connectedRoom.global_position.distance_to(connectedRoomDoor.global_position)
	var connectedRoomDirection = connectedRoom.global_position.direction_to(connectedRoomDoor.global_position).normalized()

	#Create the offset from connected room, to connected door, and new door to new room.
	var connectedRoomOffset = connectedRoom.global_position + (connectedRoomDirection * connectedDistance)
	var newRoomOffset = newRoom.global_position + (newRoomDirection * newDistance)
	
	#Add it all together with the distance between the two doors
	var newRoomPosition = newRoomOffset + connectedRoomOffset + direction
	
	return newRoomPosition

func _on_button_pressed():
	randomize()
	generate_dungeon(randi_range(-1000, 1000))
