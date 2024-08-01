extends CharacterBody2D
class_name ResourceDrop

@export var sprite: AnimatedSprite2D
@export var collider: CollisionShape2D

var resType

#Physics Variables
const maxForce = 13
const minForce = 8
var spawnDir: Vector2
var spawnForce: float
var spawning = false

func _physics_process(delta):
	if !spawning: return
	spawnForce -= delta * 0.5
	velocity = spawnDir * (spawnForce)
	move_and_slide()

func spawn(type: ResourceType.ResourceType, direction: Vector2):
	#Apply Resource Type & Visuals
	sprite.frame = type
	sprite.visible = true
	resType = type
	z_index = 4
	
	#Apply Physics
	spawnDir = direction
	spawnForce = randf_range(minForce, maxForce)
	velocity = direction * spawnForce
	move_and_slide()
	
	spawning = true
	await get_tree().create_timer(0.1).timeout
	spawning = false

func pickup():
	collider.disabled = true
	z_index = 6
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_body_entered(body):
	#Check if body entering area is the player AND if it has the ability to hold more resources!
	if body.is_in_group("Player") and body.heldResources.size() < body.maxHeldResources:
		pickup()
		body.PickedUpResource(self)

func deposit(parent):
	pass
