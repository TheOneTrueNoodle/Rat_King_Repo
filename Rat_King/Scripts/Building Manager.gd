extends Node2D

var buildings = {}

func _ready():
	# Get list of all building nodes in the scene
	for building in get_tree().get_nodes_in_group("Building"):
		# Now add to buildings dictionary with building name as the key. 
		#We dont need the main functionality of the building, just a reference to its handler
		buildings[building.get_node("Building").buildingName] = building.get_node("Building")

func LevelUpBuilding(building: String):
	buildings[building].levelUp()
