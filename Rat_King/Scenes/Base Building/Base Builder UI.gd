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

# Resource Display Variables
@onready var resourceBuilding = $"../Resource Building"

@onready var woodText = $"Resources Display/Wood/RichTextLabel"
@onready var stoneText = $"Resources Display/Stone/RichTextLabel"
@onready var metalText = $"Resources Display/Metal/RichTextLabel"
@onready var medicineText = $"Resources Display/Medicine/RichTextLabel"
@onready var foodText = $"Resources Display/Food/RichTextLabel"
@onready var teethText = $"Resources Display/Teeth/RichTextLabel"

func updateResourceDisplay():
	woodText.text = str(resourceBuilding.resources["Wood"]) + " / " + str(resourceBuilding.baseMaxResource * resourceBuilding.buildingData.currentLevel)
	stoneText.text = str(resourceBuilding.resources["Stone"]) + " / " + str(resourceBuilding.baseMaxResource * resourceBuilding.buildingData.currentLevel)
	metalText.text = str(resourceBuilding.resources["Metal"]) + " / " + str(resourceBuilding.baseMaxResource * resourceBuilding.buildingData.currentLevel)
	medicineText.text = str(resourceBuilding.resources["Medicine"]) + " / " + str(resourceBuilding.baseMaxResource * resourceBuilding.buildingData.currentLevel)
	foodText.text = str(resourceBuilding.resources["Food"]) + " / " + str(resourceBuilding.baseMaxResource * resourceBuilding.buildingData.currentLevel)

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
		
		#Check if upgrade is affordable and can build it
		newButton.disabled = CheckUpgradeCost(building)
		
		spawnedButtons[spawnedButtons.size()] = newButton

func closeConstructionMenu():
	openConstructionButton.visible = true
	constructionMenu.visible = false

func CheckUpgradeCost(building: Building):
	if building.currentLevel >= constructionBuilding.buildingData.currentLevel and building != constructionBuilding.buildingData:
		return true
	
	#Check each resource type for cost
	if resourceBuilding.resources["Wood"] < (building.baseWoodCost * (building.currentLevel + 1)):
		return true
	if resourceBuilding.resources["Stone"] < (building.baseStoneCost * (building.currentLevel + 1)):
		return true
	if resourceBuilding.resources["Metal"] < (building.baseMetalCost * (building.currentLevel + 1)):
		return true
	if resourceBuilding.resources["Medicine"] < (building.baseMedicineCost * (building.currentLevel + 1)):
		return true
	if resourceBuilding.resources["Food"] < (building.baseFoodCost * (building.currentLevel + 1)):
		return true
	return false