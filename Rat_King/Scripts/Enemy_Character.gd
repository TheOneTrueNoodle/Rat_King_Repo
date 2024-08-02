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
var animState = IDLE
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
enum AI_STATE{
	WANDER,
	CHASE
}

var state: AI_STATE = AI_STATE.WANDER
@export var team: int = 1
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var chaseTimer:= $"NavigationAgent2D/Chase Timer" as Timer

#Wander stuff
const minWalkDistance = 30
const maxWalkDistance = 60
const wanderTimeMin = 1
const wanderTimeMax = 3
var currentWanderTime: float = 0

#Resource Stuff
@export var resourceScene: PackedScene

#Spawner info
var spawner
var spawned: bool = false

func _ready():
	PlayerNode = get_tree().get_nodes_in_group("Player")[0]
	healthComponent.loseHealth.connect(takeDamage)
	aggroComponent.callAggro.connect(aggro)

func _physics_process(delta):
	if state == AI_STATE.WANDER:
		#Wander state
		wander(delta)
	
	if stunned:
		velocity = -knockbackDir * 5
		move_and_slide()
		return
	
	if state == AI_STATE.CHASE:
		if attacking && attackWindUp > 0:
			attackWindUp -= delta
			if attackWindUp <= 0:
				attack()
			return
		elif attacking:
			return
		else:
			chase(delta)
	
	animate()
	aim()
	
	var distance: float = global_position.distance_to(PlayerNode.global_position)
	#print(distance)
	if distance <= attackRange:
		attackCall()

func wander(delta):
	#Get direction
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	
	#Update Wander Time
	currentWanderTime -= delta
	if currentWanderTime <= 0:
		dir = Vector2.ZERO
	
	move(delta,dir)

func chase(delta):
	#Get direction
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	move(delta,dir)

func move(delta, dir: Vector2):
	if dir == Vector2.ZERO:
		animState = IDLE
		apply_friction(frict * delta)
	else:
		animState = MOVE
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
	state_machine.travel(animTree_state_keys[animState])
	animationTree.set(blend_pos_paths[animState], blend_position)

func aim() -> void:
	if weapon_component:
		weapon_component.look_at(PlayerNode.global_position)

func attackCall() -> void:
	attacking = true
	attackWindUp = 0.3
	sprite.modulate = Color(1,0,0,2)
	
	animState = IDLE
	var dir = PlayerNode.global_position - global_position
	blend_position = dir
	
	state_machine.travel(animTree_state_keys[animState])
	animationTree.set(blend_pos_paths[animState], dir)

func attack() -> void:
	#Attack Function
	weapon_component.attack()

func onAttackEnd():
	sprite.modulate = Color.GREEN
	await get_tree().create_timer(attackCooldown).timeout
	attacking = false

func aggro():
	state = AI_STATE.CHASE
	makePath()
	chaseTimer.start()

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
	var newResource = resourceScene.instantiate()
	get_tree().root.add_child(newResource)
	newResource.global_position = global_position
	newResource.spawn(ResourceType.ResourceType.Flesh, -knockbackDir)
	queue_free()

#Damage Feedback
func takeDamage(amount):
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

func makePath():
	nav_agent.target_position = PlayerNode.global_position

func getWanderDestination():
	var wanderDir = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
	var wanderDist = randi_range(minWalkDistance, maxWalkDistance)
	var targetWanderPos = global_position + (wanderDir * wanderDist)
	
	
	return targetWanderPos

func makeWanderPath():
	nav_agent.target_position = getWanderDestination()
	currentWanderTime = randf_range(wanderTimeMin, wanderTimeMax)

func _on_chase_timer_timeout():
	if state == AI_STATE.CHASE:
		makePath()

func _on_wander_timer_timeout():
	if state == AI_STATE.WANDER:
		makeWanderPath()
