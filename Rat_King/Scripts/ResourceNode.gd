extends StaticBody2D
class_name ResourceNode

#Resource Stuff
@export var type: ResourceType.ResourceType
@export var resourceScene: PackedScene

#Health Stuff
@onready var healthComponent = $HealthComponent

#Animation Stuff
@onready var sprite = $TileMap

func _ready():
	healthComponent.loseHealth.connect(takeDamage)
	get_parent().remove_child(self)

#Damage Feedback
func takeDamage(amount):
	#Handle sprite colors
	sprite.modulate = Color(10,10,10,10)
	
	#Drop resource
	var newResource = resourceScene.instantiate()
	get_tree().root.add_child(newResource)
	newResource.global_position = global_position + (Vector2.RIGHT * 5)
	newResource.spawn(type)
	
	#Wait
	await get_tree().create_timer(0.1).timeout
	
	#Reset node
	sprite.modulate = Color(1,1,1,1)

func die():
	#Handle sprite colors
	sprite.modulate = Color(10,10,10,10)
	
	#Drop resource
	var newResource = resourceScene.instantiate()
	get_tree().root.add_child(newResource)
	newResource.global_position = global_position + (Vector2.RIGHT * 5)
	newResource.spawn(type)
	
	#Wait
	await get_tree().create_timer(0.1).timeout
	
	#Delete Node
	queue_free()
