extends Node2D
class_name HealthComponent

signal healHealth
signal loseHealth(amount)
signal died

@export var maxHealth: int = 5
var currentHealth: int

func _ready():
	currentHealth = maxHealth
	died.connect(owner.die)

func heal(value: int):
	currentHealth += value
	healHealth.emit(value)
	if currentHealth > maxHealth:
		currentHealth = maxHealth

func damage(value: int):
	currentHealth -= value
	print(currentHealth)
	if currentHealth <= 0:
		die()
	else:
		loseHealth.emit(value)

func die():
	died.emit()
