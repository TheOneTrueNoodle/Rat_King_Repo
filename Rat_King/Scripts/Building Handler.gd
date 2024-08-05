extends Node2D
class_name Building

@export var buildingName: String

@export var maxLevel: int = 20
@export var currentLevel: int = 0

#Resource costs to upgrade!
@export_group("Building Costs")
@export var baseWoodCost: int = 0
@export var baseStoneCost: int = 0
@export var baseMetalCost: int = 0
@export var baseMedicineCost: int = 0
@export var baseFoodCost: int = 0

func levelUp():
	currentLevel += 1
