extends Node2D
class_name Building

@export var buildingName: String

@export var maxLevel: int = 20
@export var currentLevel: int = 0

#Resource costs to upgrade!
@export var baseCosts: Dictionary = {
	"Wood" = 0,
	"Stone" = 0,
	"Metal" = 0,
	"Medicine" = 0,
	"Food" = 0
}

func levelUp():
	currentLevel += 1
