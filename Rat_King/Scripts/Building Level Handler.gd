extends Node2D
class_name BuildingLevel

@export var maxLevel: int = 20
@export var currentLevel: int = 0

func levelUp():
	currentLevel += 1
