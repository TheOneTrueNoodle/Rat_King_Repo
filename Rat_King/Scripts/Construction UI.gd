extends Control

#UI Stuff
@onready var constructionMenu = $"Construction Menu"
@onready var openConstructionButton = $"Construction Button"
var constructionMenuOpen: bool = false

# Building Stuff
@onready var constructionBuilding = $"../../Construction Building"

# Building Select Stuff
@export var buildingUpgradeButton: PackedScene
@onready var buildingUpgradeButtonContainer = $"Construction Menu/Panel/ScrollContainer/VBoxContainer"
var spawnedButtons = {}

# Data Variables
var buildingManager
var resourceBuilding

func setup(newBuildingManager, newResourceManager):
	buildingManager = newBuildingManager
	resourceBuilding = newResourceManager
	DayManager.dayPassed.connect(openConstructionMenu)

func openConstructionMenu():
	openConstructionButton.visible = false
	constructionMenu.visible = true
	constructionMenuOpen = true
	
	# Delete previously made buttons
	if spawnedButtons.size() > 0:
		for i in range(spawnedButtons.size()-1, -1, -1):
			spawnedButtons[i].queue_free()
	spawnedButtons = {}
	
	# Now create menu buttons for every building to upgrade!!!
	for building: Building in buildingManager.buildings.values():
		# Spawn new button
		var newButton = buildingUpgradeButton.instantiate()
		buildingUpgradeButtonContainer.add_child(newButton)
		
		#Set button Displays
		newButton.setupButtonVisuals(building)
		
		# Set button signals
		newButton.pressed.connect(constructionBuilding.startUpgrading.bind(building))
		newButton.pressed.connect(self.openConstructionMenu)
		
		#Check if upgrade is affordable and can build it
		newButton.disabled = CanUpgrade(building)
		
		spawnedButtons[spawnedButtons.size()] = newButton

func closeConstructionMenu():
	openConstructionButton.visible = true
	constructionMenu.visible = false
	constructionMenuOpen = false

func CanUpgrade(building: Building):
	if constructionBuilding.upgrading: return true
	
	if building.currentLevel >= constructionBuilding.buildingData.currentLevel and building != constructionBuilding.buildingData:
		return true
	
	#Check each resource type for cost
	for key in building.baseCosts.keys():
		if resourceBuilding.resources[key] < building.baseCosts[key]: return true
	
	return false

