extends Button

@onready var ResourceBuilding = $"../../Resource Building"

func _on_pressed():
	var amount = randi_range(5, 11)
	
	var type = randi_range(0,4)
	if type == 0: ResourceBuilding.increaseResource("Wood", amount)
	elif type == 1: ResourceBuilding.increaseResource("Stone", amount)
	elif type == 2: ResourceBuilding.increaseResource("Metal", amount)
	elif type == 3: ResourceBuilding.increaseResource("Medicine", amount)
	elif type == 4: ResourceBuilding.increaseResource("Food", amount)
