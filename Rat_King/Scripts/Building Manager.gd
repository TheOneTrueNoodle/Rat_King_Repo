extends Node2D

var buildings = {}

func _ready():
	#Get list of all building nodes in the scene
	buildings = get_tree().get_nodes_in_group("Building")
	print(buildings[0].key())
