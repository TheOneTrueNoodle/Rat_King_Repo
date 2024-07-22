extends Area2D
class_name HitBox

@export var damage: int = 1
@export var team: int # = = player, 1 = enemy

@onready var animationPlayer = $AnimationPlayer
var attacking: bool = false

signal attackEnd

func _init():
	collision_layer = 2
	collision_mask = 0

func attack():
		#Play animation
		animationPlayer.play("Attack")
		attacking = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		#Trigger code for attack finishing
		attacking = false
		attackEnd.emit()
