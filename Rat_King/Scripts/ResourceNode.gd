extends StaticBody2D
class_name ResourceNode

#Resource Stuff
@export var ResourceType: ResourceType.ResourceType
var resourceScene = preload()

#Health Stuff
@onready var healthComponent = $HealthComponent

#Animation Stuff
@onready var sprite = $AnimatedSprite2D

func _ready():
	healthComponent.loseHealth.connect(takeDamage)
	reparent(self)

#Damage Feedback
func takeDamage(amount):
	#Handle sprite colors
	sprite.modulate = Color(10,10,10,10)
	
	#Drop resource
	
	
	#Wait
	await get_tree().create_timer(0.1).timeout
	
	#Reset node
	sprite.modulate = Color(1,1,1,1)
