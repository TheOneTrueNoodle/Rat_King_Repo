extends CanvasLayer

# Data Variables
@onready var buildingManager = $"../Building Manager"

# Construction Menu Variables
@onready var constructionBuilding = $"../Construction Building"

@onready var constructionMenu = $"Construction Menu"
@onready var openConstructionButton = $"Construction Button"

@export var buildingUpgradeButton: PackedScene
@onready var buildingUpgradeButtonContainer = $"Construction Menu/Panel/ScrollContainer/VBoxContainer"
var spawnedButtons = {}

func openConstructionMenu():
	openConstructionButton.visible = false
	constructionMenu.visible = true
	
	# Delete previously made buttons
	if spawnedButtons.size() > 0:
		for i in range(spawnedButtons.size()-1, -1, -1):
			spawnedButtons[i].queue_free()
	spawnedButtons = {}
	
	# Now create menu buttons for every building to upgrade!!!
	for building in buildingManager.buildings.values():
		# Spawn new button
		var newButton = buildingUpgradeButton.instantiate()
		buildingUpgradeButtonContainer.add_child(newButton)
		
		# Set button text
		newButton.text = building.buildingName + ": Lv " + str(building.currentLevel) + " -> " + str(building.currentLevel + 1)
		# Set button signals
		newButton.pressed.connect(constructionBuilding.upgradeBuilding.bind(building))
		newButton.pressed.connect(self.openConstructionMenu)
		
		if building.currentLevel >= constructionBuilding.buildingData.currentLevel and building != constructionBuilding.buildingData:
			newButton.disabled = true
		
		spawnedButtons[spawnedButtons.size()] = newButton

func closeConstructionMenu():
	openConstructionButton.visible = true
	constructionMenu.visible = false

