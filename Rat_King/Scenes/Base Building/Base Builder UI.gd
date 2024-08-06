extends CanvasLayer

# Data Variables
@onready var buildingManager = $"../Building Manager"

# UI Handlers
@onready var constructionUI = $"Construction Parent"

# Resource Display Variables
@onready var resourceBuilding = $"../Resource Building"

@onready var woodText = $"Resources Display/Wood/RichTextLabel"
@onready var stoneText = $"Resources Display/Stone/RichTextLabel"
@onready var metalText = $"Resources Display/Metal/RichTextLabel"
@onready var medicineText = $"Resources Display/Medicine/RichTextLabel"
@onready var foodText = $"Resources Display/Food/RichTextLabel"
@onready var teethText = $"Resources Display/Teeth/RichTextLabel"

func _ready():
	constructionUI.setup(buildingManager, resourceBuilding)

func updateResourceDisplay():
	# Update text
	woodText.text = str(resourceBuilding.resources["Wood"]) + " / " + str(resourceBuilding.baseMaxResource * resourceBuilding.buildingData.currentLevel)
	stoneText.text = str(resourceBuilding.resources["Stone"]) + " / " + str(resourceBuilding.baseMaxResource * resourceBuilding.buildingData.currentLevel)
	metalText.text = str(resourceBuilding.resources["Metal"]) + " / " + str(resourceBuilding.baseMaxResource * resourceBuilding.buildingData.currentLevel)
	medicineText.text = str(resourceBuilding.resources["Medicine"]) + " / " + str(resourceBuilding.baseMaxResource * resourceBuilding.buildingData.currentLevel)
	foodText.text = str(resourceBuilding.resources["Food"]) + " / " + str(resourceBuilding.baseMaxResource * resourceBuilding.buildingData.currentLevel)
	
	#Check which menu is open if any
	if constructionUI.constructionMenuOpen: constructionUI.openConstructionMenu()

func openBlacksmithDisplay():
	pass

func closeBlacksmithDisplay():
	pass
