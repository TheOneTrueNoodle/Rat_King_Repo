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
	spentResource.emit("Wood", building.baseWoodCost * building.currentLevel)
	spentResource.emit("Stone", building.baseStoneCost * building.currentLevel)
	spentResource.emit("Metal", building.baseMetalCost * building.currentLevel)
	spentResource.emit("Medicine", building.baseMedicineCost * building.currentLevel)
	spentResource.emit("Food", building.baseFoodCost * building.currentLevel)
