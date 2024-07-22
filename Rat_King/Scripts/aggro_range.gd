extends Area2D
class_name AggroRange

@export var team: int # 0 = player, 1 = enemy
signal callAggro

func _init() -> void:
	collision_layer = 0
	collision_mask = 1

func _on_body_entered(player: Player) -> void:
	print("Collision Detected")
	if player == null:
		print("Character Null")
		return
	if player.team == team:
		print("Same Team")
		return
	
	print("Aggroing")
	callAggro.emit()
