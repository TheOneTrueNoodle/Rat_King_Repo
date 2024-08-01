extends Area2D
class_name AggroRange

@export var team: int # 0 = player, 1 = enemy
signal callAggro

func _init() -> void:
	collision_layer = 0
	collision_mask = 1

func _on_body_entered(body) -> void:
	print("Collision Detected")
	if !body.is_in_group("Player"):
		return
	if body == null:
		print("Character Null")
		return
	if body.team == team:
		print("Same Team")
		return
	
	print("Aggroing")
	callAggro.emit()
