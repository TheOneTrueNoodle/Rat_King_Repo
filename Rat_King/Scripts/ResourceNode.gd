extends StaticBody2D
class_name ResourceNode

#Resource Stuff
@export var type: ResourceType.ResourceType
@export var resourceScene: PackedScene
var knockbackDir = Vector2.ZERO

#Health Stuff
@onready var healthComponent = $HealthComponent

#Animation Stuff
@onready var sprite = $TileMap

func _ready():
	healthComponent.loseHealth.connect(takeDamage)

func knockback(source: Node2D):
	knockbackDir = source.global_position - global_position #Get knockback direction

#Damage Feedback
func takeDamage(amount):
	#Handle sprite colors
	sprite.modulate = Color(10,10,10,10)
	
	#Drop resource
	var newResource = resourceScene.instantiate()
	newResource.global_position = global_position
	get_tree().root.add_child(newResource)
	newResource.spawn(type, -knockbackDir)
	print(knockbackDir)
	
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
	newResource.global_position = global_position
	newResource.spawn(type, -knockbackDir)
	
	#Wait
	await get_tree().create_timer(0.1).timeout
	
	#Delete Node
	queue_free()
