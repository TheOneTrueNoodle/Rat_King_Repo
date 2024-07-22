extends Node2D
class_name Room

@export var northDoor: Node2D
@export var southDoor: Node2D
@export var eastDoor: Node2D
@export var westDoor: Node2D

var spawnedDirection: Vector2 #What direction was this room spawned in

@export var roomArea: Area2D

var connected_rooms = {
	"East": null, #East
	"West": null, #West
	"North": null, #North
	"South": null #South
}

var number_of_connections = 0

func check_area():
	if roomArea.has_overlapping_areas():
		return true
	else:
		return false
