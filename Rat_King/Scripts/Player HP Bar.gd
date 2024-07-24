extends Control
class_name PlayerHPBar

@export var hpBar: HSlider

func change_hp_value(amount):
	hpBar.value -= amount
	print("Taken Damage")

func setup(playerNode: Player):
	hpBar.min_value = 0
	hpBar.max_value = playerNode.healthComponent.maxHealth
	hpBar.value = hpBar.max_value
	playerNode.changeHealth.connect(change_hp_value)
