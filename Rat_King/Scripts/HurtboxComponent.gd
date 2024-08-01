extends Area2D
class_name HurtBox

@export var team: int # 0 = player, 1 = enemy
var enabled: bool = true

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null or hitbox.team == team or enabled == false:
		return
	
	print("Detected Hit")
	
	if owner.is_in_group("Player") or owner.is_in_group("Resource"):
		owner.knockback(hitbox)
	if owner.has_node("HealthComponent"):
		owner.get_node("HealthComponent").damage(hitbox.damage)
