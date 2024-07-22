extends Area2D
class_name HurtBox

@export var team: int # 0 = player, 1 = enemy

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	
	if hitbox.team == team:
		return
	
	if owner.has_node("HealthComponent"):
		owner.get_node("HealthComponent").damage(hitbox.damage)
