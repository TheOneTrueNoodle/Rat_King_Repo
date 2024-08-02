extends Node2D
class_name Room

@export var northDoor: RoomDoor
@export var southDoor: RoomDoor
@export var eastDoor: RoomDoor
@export var westDoor: RoomDoor

var spawnedDirection: Vector2 #What direction was this room spawned in

@export var roomArea: Area2D

var spawnOrder: int

#var EastRoom: Room = null
#var NorthRoom: Room = null
#var SouthRoom: Room = null
#var WestRoom: Room = null

var connected_rooms = {
	"East": null, #East
	"West": null, #West
	"North": null, #North
	"South": null #South
}

var number_of_connections = 0

func check_area():
	if roomArea.has_overlapping_areas():
		var overlappedRooms = roomArea.get_overlapping_areas()
		for i in overlappedRooms:
			print(i)
			if i.owner.spawnOrder < spawnOrder:
				return true
		return false
	else:
		return false

func open_connected_doors():
	if northDoor != null and connected_rooms["North"] != null: northDoor.openDoor()
	if southDoor != null and connected_rooms["South"] != null: southDoor.openDoor()
	if eastDoor != null and connected_rooms["East"] != null: eastDoor.openDoor()
	if westDoor != null and connected_rooms["West"] != null: westDoor.openDoor()
	pass
