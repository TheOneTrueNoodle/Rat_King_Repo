extends Node2D

@onready var buildingData: Building = $Building

signal spentResource(type: String, cost: int)

var upgrading: bool = false # Bool for if we are upgrading something!
var currentBuilding: Building # Save what building is being upgraded!
var daysPassed

func startUpgrading(building: Building):
	#Check if can upgrade as normal!
	#Listen for the day passing signal! Set variable to stop more constructions happening!
	if building.currentLevel < building.maxLevel and building.currentLevel < buildingData.currentLevel:
		currentBuilding = building
		spendResource(building)
		upgrading = true
		daysPassed = 0
		
		var taskNameString = "Upgrade " + building.buildingName
		if building.currentLevel == 0: taskNameString = "Build " + building.buildingName
		
		DayManager.startTask(finishUpgrade, building.timeToUpgrade, taskNameString)
	elif building == buildingData:
		currentBuilding = building
		spendResource(building)
		upgrading = true
		daysPassed = 0
		
		var taskNameString = "Upgrade " + building.buildingName
		if building.currentLevel == 0: taskNameString = "Build " + building.buildingName
		
		DayManager.startTask(finishUpgrade, building.timeToUpgrade, taskNameString)

func finishUpgrade():
	currentBuilding.levelUp()
	upgrading = false
	
	#Now stop listening for the days passing. 
	DayManager.pauseTimer()

func spendResource(building: Building):
	# Handle spent resources
	for key in building.baseCosts.keys():
		# Key is the string of the resource type!
		if building.baseCosts[key] == 0: continue
		
		var levelMult = 1 if building.currentLevel == 0 else building.currentLevel
		spentResource.emit(key, building.baseCosts[key] * levelMult)
