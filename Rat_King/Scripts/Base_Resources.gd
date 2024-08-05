extends Node2D

#This script handles all resources currently in the base!
@onready var buildingLevel: Building = $"Building Level Handler"

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
	if(resources[resource] > (baseMaxResource * buildingLevel.currentLevel)):
		resources[resource] = baseMaxResource *  buildingLevel.currentLevel

func decreaseResource(resource:String, amount: int):
	resources[resource] -= amount
	if resources[resource] < 0:
		resources[resource] = 0
