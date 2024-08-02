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

#Runtime Generating Variables
var newRooms = {} #A dictionary of all rooms generated in the previous frame
var currentSize
var generating: bool = false

signal finishedLoading

func _ready():
	randomize()
	generate_new_dungeon(randi_range(-1000, 1000))

func generate_new_dungeon(room_seed):
	#Reset variables
	dungeon = {}
	newRooms = {}
	currentSize = floor(randi_range(min_number_rooms, max_number_of_rooms))
	
	var currentRoomHolder = dungeon_type.instantiate()
	possible_rooms = currentRoomHolder.rooms
	
	#Removes previously generated dungeons
	for i in range(0, map_node.get_child_count()):
		map_node.get_child(i).queue_free()
	
	#Enter seed
	seed(room_seed)
	
	#Spawn Start Room
	dungeon[0] = currentRoomHolder.startingRooms[randi_range(0, currentRoomHolder.startingRooms.size()-1)].instantiate()
	dungeon[0].position = Vector2.ZERO
	dungeon[0].z_index = 1
	dungeon[0].spawnOrder = -1
	map_node.add_child(dungeon[0])
	currentSize -= 1
	
	generating = true

func _physics_process(delta):
	if !generating:
		return
	
	var roomsToDelete = {}
	
	#Clear any overlapping rooms
	for i in range(newRooms.size()-1, -1, -1):
		#If overlaps and is not the oldest room, delete it
		if newRooms[i].check_area() == true:
			#CLEAR ITS CONNECTIONS!!!!
			if newRooms[i].connected_rooms["East"] != null:
				newRooms[i].connected_rooms["East"].connected_rooms["West"] = null
			if newRooms[i].connected_rooms["West"] != null:
				newRooms[i].connected_rooms["West"].connected_rooms["East"] = null
			if newRooms[i].connected_rooms["North"] != null:
				newRooms[i].connected_rooms["North"].connected_rooms["South"] = null
			if newRooms[i].connected_rooms["South"] != null:
				newRooms[i].connected_rooms["South"].connected_rooms["North"] = null
			
			roomsToDelete[roomsToDelete.size()] = newRooms[i]
		#Else, add that shit to the FUCKING DUNGEON BABY
		else:
			#CHECK IF IT HAS ANY REMAINING CONNECTIONS
			var hasConnection: bool = false
			for room in newRooms[i].connected_rooms.values():
				if room != null:
					hasConnection = true
					break
			if hasConnection == true:
				newRooms[i].spawnOrder = dungeon.size()
				dungeon[dungeon.size()] = newRooms[i]
				currentSize -= 1
				newRooms.erase(i)
			else:
				roomsToDelete[roomsToDelete.size()] = newRooms[i]
	
	
	#Clear bad rooms
	if roomsToDelete.size() > 0:
		for i in range(roomsToDelete.size()-1, -1, -1):
			print(roomsToDelete[i])
			roomsToDelete[i].queue_free()
			
	newRooms = {}
	
	#Generate new rooms this frame
	if currentSize > 0:
		for i in dungeon.keys():
			#Check Generation Chance to see if a room spawns off of this room
			if(randi_range(0,100) < generation_chance) and currentSize > 0:
				#Get New Room Direction
				var direction = randi_range(0,4)
				# TODO: Create function to set directional rooms 'dungeon[i].setXRoom(newRoom)
					# dungeon[i].setRoom(direction, newRoom):
								#newRoom.setNorthRoom(this)
				#East
				if direction == 0 and dungeon[i].eastDoor != null and dungeon[i].connected_rooms["East"] == null:
					#Pick room type. New room must have a WEST entrance
					var roomType = randi_range(0, possible_rooms.size()-1)
					var newRoom = possible_rooms[roomType].instantiate()
					while newRoom.westDoor == null:
						newRoom.queue_free()
						roomType = randi_range(0, possible_rooms.size()-1)
						newRoom = possible_rooms[roomType].instantiate()
					#New room has a west entrance now!
					#position new room
					var pos = calculate_new_room_position(newRoom, newRoom.westDoor, dungeon[i], dungeon[i].eastDoor, Vector2.RIGHT)
					newRoom.global_position = pos
					newRoom.z_index = 1
					newRoom.spawnOrder = dungeon.size() + newRooms.size()
					
					map_node.add_child(newRoom)
					newRooms[newRooms.size()] = newRoom
					connect_rooms(dungeon[i], newRoom, "East", "West")
				
				#West
				elif direction == 1 and dungeon[i].westDoor != null and dungeon[i].connected_rooms["West"] == null:
					#Pick room type. New room must have an EAST entrance
					var roomType = randi_range(0, possible_rooms.size()-1)
					var newRoom = possible_rooms[roomType].instantiate()
					while newRoom.eastDoor == null:
						newRoom.queue_free()
						roomType = randi_range(0, possible_rooms.size()-1)
						newRoom = possible_rooms[roomType].instantiate()
					#New room has an east entrance now!
					#position new room
					var pos = calculate_new_room_position(newRoom, newRoom.eastDoor, dungeon[i], dungeon[i].westDoor, Vector2.LEFT)
					newRoom.position = pos
					newRoom.z_index = 1
					newRoom.spawnOrder =  dungeon.size() + newRooms.size()
					
					map_node.add_child(newRoom)
					newRooms[newRooms.size()] = newRoom
					connect_rooms(dungeon[i], newRoom, "West", "East")
				
				#North
				elif direction == 2 and dungeon[i].northDoor != null and dungeon[i].connected_rooms["North"] == null:
					#Pick room type. New room must have a SOUTH entrance
					var roomType = randi_range(0, possible_rooms.size()-1)
					var newRoom = possible_rooms[roomType].instantiate()
					while newRoom.southDoor == null:
						newRoom.queue_free()
						roomType = randi_range(0, possible_rooms.size()-1)
						newRoom = possible_rooms[roomType].instantiate()
					#New room has a south entrance now!
					#position new room
					var pos = calculate_new_room_position(newRoom, newRoom.southDoor, dungeon[i], dungeon[i].northDoor, Vector2.UP)
					newRoom.position = pos
					newRoom.z_index = 1
					newRoom.spawnOrder =  dungeon.size() + newRooms.size()
					
					map_node.add_child(newRoom)
					newRooms[newRooms.size()] = newRoom
					connect_rooms(dungeon[i], newRoom, "North", "South")
				
				#South
				elif direction == 3 and dungeon[i].southDoor != null and dungeon[i].connected_rooms["South"] == null:
					#Pick room type. New room must have a NORTH entrance
					var roomType = randi_range(0, possible_rooms.size()-1)
					var newRoom = possible_rooms[roomType].instantiate()
					while newRoom.northDoor == null:
						newRoom.queue_free()
						roomType = randi_range(0, possible_rooms.size()-1)
						newRoom = possible_rooms[roomType].instantiate()
					#New room has a north entrance now!
					#position new room
					var pos = calculate_new_room_position(newRoom, newRoom.northDoor, dungeon[i], dungeon[i].southDoor, Vector2.DOWN)
					newRoom.position = pos
					newRoom.z_index = 1
					newRoom.spawnOrder = dungeon.size() + newRooms.size()
					
					map_node.add_child(newRoom)
					newRooms[newRooms.size()] = newRoom
					connect_rooms(dungeon[i], newRoom, "South", "North")
	else:
		#CLOSE OFF THE EMPTY DOORWAYS IN ROOMS!!!!
		for i in dungeon.keys():
			dungeon[i].open_connected_doors()
		generating = false
		finishedLoading.emit()

# TODO: Move this into Room class, SOLID principle
func connect_rooms(oldRoom, newRoom, newDirection: String, oppositeDirection: String):
	oldRoom.connected_rooms[newDirection] = newRoom
	newRoom.connected_rooms[oppositeDirection] = oldRoom
	oldRoom.number_of_connections += 1
	newRoom.number_of_connections += 1

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
	var newRoomPosition = newRoomOffset + connectedRoomOffset + (direction * 16)
	
	return newRoomPosition

func _on_button_pressed():
	randomize()
	generate_new_dungeon(randi_range(-1000, 1000))
