extends Node2D

@onready var buildingData: Building = $Building

signal spentResource(type: String, cost: int)

func upgradeBuilding(building: Building):
	if building.currentLevel < building.maxLevel and building.currentLevel < buildingData.currentLevel:
		building.levelUp()
		spendResource(building)
	elif building == buildingData:
		building.levelUp()
		spendResource(building)

func spendResource(building: Building):
	# Handle spent resources
	for key in building.baseCosts.keys():
		# Key is the string of the resource type!
		if building.baseCosts[key] == 0: continue
		
		var levelMult = 1 if building.currentLevel == 0 else building.currentLevel
		spentResource.emit(key, building.baseCosts[key] * levelMult)
