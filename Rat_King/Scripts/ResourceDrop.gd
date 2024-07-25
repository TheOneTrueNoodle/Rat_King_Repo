extends Area2D
class_name ResourceDrop

@export var sprite: AnimatedSprite2D
@export var collider: CollisionShape2D

func spawn(type: ResourceType.ResourceType):
	sprite.frame = type
	sprite.visible = true

func pickup():
	collider.disabled = true

func _on_body_entered(body):
	#Check if body entering area is the player AND if it has the ability to hold more resources!
	if body.is_in_group("Player") and body.heldResources.size() < body.maxHeldResources:
		body.PickedUpResource(self)
		pickup()

func deposit(parent):
	pass
