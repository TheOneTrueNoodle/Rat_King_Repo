extends Node2D
class_name RoomDoor

@onready var closedDoor: TileMap = $TileMap

func openDoor():
	closedDoor.set_layer_enabled(0, false)
	pass
