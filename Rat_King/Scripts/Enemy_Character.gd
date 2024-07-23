extends CharacterBody2D

#AI Stuff
@export var PlayerNode: Node2D

#Movement Stuff
var speed: float = 60

var accel: float = 300
var frict: float = 2000

#Animation Stuff
@onready var sprite = $AnimatedSprite2D
@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree["parameters/playback"]
enum{IDLE, MOVE}
var state = IDLE
var blend_position: Vector2 = Vector2.ZERO
var blend_pos_paths = ["parameters/Idle/Idle_BlendSpace2D/blend_position", "parameters/Movement/BlendSpace2D/blend_position"]
var animTree_state_keys = ["Idle", "Movement"]

#Weapon Stuff
@export var weapon_component : Node2D
var attacking: bool = false
@export var attackRange: float = 1
var attackWindUp: float = 0
var attackCooldown: float = 0.5

#Health Stuff
@onready var healthComponent = $HealthComponent
@export var aggroComponent: AggroRange
var stunned: bool = false
var knockbackDir: Vector2 = Vector2.ZERO

#AI Stuff
var aggroActive: bool = false
@export var team: int = 1

func _ready():
	print(healthComponent)
	print(aggroComponent)
	PlayerNode = get_tree().get_nodes_in_group("Player")[0]
	healthComponent.loseHealth.connect(takeDamage)
	aggroComponent.callAggro.connect(aggro)
	reparent(self)

func _physics_process(delta):
	if !aggroActive:
		return
	if stunned:
		velocity = -knockbackDir * 5
		move_and_slide()
		return
	
	if attacking && attackWindUp > 0:
		attackWindUp -= delta
		if attackWindUp <= 0:
			attack()
		return
	elif attacking:
		return
	else:
		move(delta)
	animate()
	aim()
	
	var distance: float = global_position.distance_to(PlayerNode.global_position)
	#print(distance)
	if distance <= attackRange:
		attackCall()

func move(delta):
	#Get direction
	var dir = PlayerNode.global_position - global_position
	
	if dir == Vector2.ZERO:
		state = IDLE
		apply_friction(frict * delta)
	else:
		state = MOVE
		apply_movement(dir * accel * delta)
		blend_position = dir
	move_and_slide()

func apply_friction(amount) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func apply_movement(amount) -> void:
	velocity += amount
	velocity = velocity.limit_length(speed)

func animate() -> void:
	state_machine.travel(animTree_state_keys[state])
	animationTree.set(blend_pos_paths[state], blend_position)

func aim() -> void:
	if weapon_component:
		weapon_component.look_at(PlayerNode.global_position)

func attackCall() -> void:
	attacking = true
	attackWindUp = 0.3
	sprite.modulate = Color(1,0,0,2)
	
	state = IDLE
	var dir = PlayerNode.global_position - global_position
	blend_position = dir
	
	state_machine.travel(animTree_state_keys[state])
	animationTree.set(blend_pos_paths[state], dir)

func attack() -> void:
	#Attack Function
	weapon_component.attack()

func onAttackEnd():
	sprite.modulate = Color.GREEN
	await get_tree().create_timer(attackCooldown).timeout
	attacking = false

func aggro():
	aggroActive = true

func die():
	#Stun enemy
	attacking = false
	attackWindUp = 0
	stunned = true
	
	#Knockback
	knockbackDir = PlayerNode.global_position - global_position #Get knockback direction
	velocity = -knockbackDir * 5
	move_and_slide()
	#Handle sprite colors
	sprite.modulate = Color(10,10,10,10)
	#Wait
	await get_tree().create_timer(0.1).timeout
	#Delete enemy and spawn loot
	queue_free()

#Damage Feedback
func takeDamage():
	#Stun enemy
	attacking = false
	attackWindUp = 0
	stunned = true
	
	#Knockback
	knockbackDir = PlayerNode.global_position - global_position #Get knockback direction
	velocity = -knockbackDir * 5
	move_and_slide()
	
	#Handle sprite colors
	sprite.modulate = Color(10,10,10,10)
	
	#Wait
	await get_tree().create_timer(0.1).timeout
	
	#Reset enemy
	sprite.modulate = Color.GREEN
	stunned = false
	knockbackDir = Vector2.ZERO
