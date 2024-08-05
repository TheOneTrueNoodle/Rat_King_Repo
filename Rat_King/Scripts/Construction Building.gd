extends Node2D

@onready var buildingData: Building = $Building

func upgradeBuilding(building: Building):
	if building.currentLevel < building.maxLevel and building.currentLevel < buildingData.currentLevel:
		building.levelUp()
	elif building == buildingData:
		building.levelUp()
