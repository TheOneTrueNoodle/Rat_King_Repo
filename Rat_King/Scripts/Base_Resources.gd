extends Node2D

#This script handles all resources currently in the base!
@onready var buildingData: Building = $Building

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
	resources[resource] += amount
	if(resources[resource] > (baseMaxResource * buildingData.currentLevel)):
		resources[resource] = baseMaxResource *  buildingData.currentLevel

func decreaseResource(resource:String, amount: int):
	resources[resource] -= amount
	if resources[resource] < 0:
		resources[resource] = 0
