extends Node2D

#This script handles all resources currently in the base!
@onready var buildingData: Building = $Building

signal resourcesChanged

var teeth: int #Currency!

var baseMaxResource = 30
var resources = {
	"Wood" = 0,
	"Stone" = 0,
	"Food" = 0,
	"Medicine" = 0,
	"Metal" = 0
} 

func increaseResource(resource: String, amount: int):
	resources[resource] = resources[resource] + amount
	if(resources[resource] > (baseMaxResource * buildingData.currentLevel)):
		resources[resource] = baseMaxResource *  buildingData.currentLevel
	
	resourcesChanged.emit()

func decreaseResource(resource:String, amount: int):
	resources[resource] = resources[resource] - amount
	if resources[resource] < 0:
		resources[resource] = 0
	
	resourcesChanged.emit()
