extends Button

var costs = {}
@export var costDisplayScene: PackedScene
@export var costDisplayParent: HBoxContainer

@onready var textDisp = $RichTextLabel

func setupButtonVisuals(building: Building):
	# Set button text
	textDisp.text = building.buildingName + ": Lv " + str(building.currentLevel) + " -> " + str(building.currentLevel + 1)
	
	#Spawn button displays
	for key in building.baseCosts.keys():
		if building.baseCosts[key] > 0:
			#Needs a resource cost disp
			var newCost = costDisplayScene.instantiate()
			costDisplayParent.add_child(newCost)
			
			var levelMult = 1 if building.currentLevel == 0 else building.currentLevel
			
			newCost.setup(building.baseCosts[key] * levelMult, key)
