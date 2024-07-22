extends Node2D

var room_holder = preload("res://Scenes/Procedural Generation/Forest Rooms/forest_rooms.tscn")
var possible_rooms: Array[PackedScene]

@export var min_number_rooms: int = 6
@export var max_number_of_rooms: int = 10

var generation_chance = 20 #percent

func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var size = floor(randi_range(min_number_rooms, max_number_of_rooms))
	
	var room_holder_in_run = room_holder.instantiate()
	#if room_holder_in_run.is_class("RoomHolder"):
	
	possible_rooms = room_holder_in_run.rooms
	dungeon[Vector2.ZERO] = possible_rooms[0].instantiate()
	
	#Pick and Assign room
	
	size -= 1
	
	while(size > 0):
		for i in dungeon.keys():
			if(randi_range(0,100) < generation_chance) and size > 0:
				#Get New Room Direction
				var direction = randi_range(0,4)
				
				#East
				if direction < 1:
					var new_room_position = i + Vector2(1,0)
					if dungeon[i].eastDoor != null:
						if !dungeon.has(new_room_position):
							#Pick room type
							var roomType = randi_range(0, possible_rooms.size()-1)
							#Spawn room
							dungeon[new_room_position] = possible_rooms[roomType].instantiate()
							dungeon[new_room_position].spawnedDirection = Vector2(1,0)
							size -= 1
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(1,0))
				
				#West
				elif direction < 2:
					var new_room_position = i + Vector2(-1,0)
					if dungeon[i].westDoor != null:
						if !dungeon.has(new_room_position):
							#Pick room type
							var roomType = randi_range(0, possible_rooms.size()-1)
							#Spawn room
							dungeon[new_room_position] = possible_rooms[roomType].instantiate()
							dungeon[new_room_position].spawnedDirection = Vector2(-1,0)
							size -= 1
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(-1,0))
				
				#North
				elif direction < 3:
					var new_room_position = i + Vector2(0,1)
					if dungeon[i].northDoor != null:
						if !dungeon.has(new_room_position):
							#Pick room type
							var roomType = randi_range(0, possible_rooms.size()-1)
							#Spawn room
							dungeon[new_room_position] = possible_rooms[roomType].instantiate()
							dungeon[new_room_position].spawnedDirection = Vector2(0,1)
							size -= 1
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(0,1))
				
				#South
				elif direction < 4:
					var new_room_position = i + Vector2(0,-1)
					if dungeon[i].southDoor != null:
						if !dungeon.has(new_room_position):
							#Pick room type
							var roomType = randi_range(0, possible_rooms.size()-1)
							#Spawn room
							dungeon[new_room_position] = possible_rooms[roomType].instantiate()
							dungeon[new_room_position].spawnedDirection = Vector2(0,-1)
							size -= 1
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(0,-1))
	return dungeon

func connect_rooms(room1, room2, direction):
	room1.connected_rooms[direction] = room2
	room2.connected_rooms[-direction] = room1
	room1.number_of_connections += 1
	room2.number_of_connections += 1


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
