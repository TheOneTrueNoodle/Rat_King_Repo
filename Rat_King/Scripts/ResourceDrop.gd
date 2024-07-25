extends Area2D
class_name ResourceDrop

@onready var sprite = $AnimatedSprite2D

func spawn(type: ResourceType.ResourceType):
	sprite.frame = type
	sprite.visible = true

func pickup():
	pass
