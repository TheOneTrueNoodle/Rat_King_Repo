extends CharacterBody2D
class_name Player

#Movement Stuff
var speed: float = 120
var accel: float = 1000
var frict: float = 2000

#Animation Stuff
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

#Health Stuff
@onready var healthComponent = $HealthComponent
@onready var sprite = $AnimatedSprite2D

#Handling Stuff
@export var team: int = 0


func _ready():
	healthComponent.loseHealth.connect(takeDamage)

func _physics_process(delta):
	if attacking:
		return
	
	move(delta)
	animate()
	aim()
	if Input.is_action_just_pressed("Attack") && weapon_component:
		attack()

func move(delta):
	var input_vector: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	if input_vector == Vector2.ZERO:
		state = IDLE
		apply_friction(frict * delta)
	else:
		state = MOVE
		apply_movement(input_vector * accel * delta)
		blend_position = input_vector
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
		weapon_component.look_at(get_global_mouse_position())

func attack() -> void:
		attacking = true
		
		weapon_component.attack()
		state = IDLE
		var dir = get_global_mouse_position() - position
		blend_position = dir
		
		state_machine.travel(animTree_state_keys[state])
		animationTree.set(blend_pos_paths[state], dir)

func onAttackEnd():
	attacking = false

func die():
	get_tree().quit()

#Damage Feedback
func takeDamage():
	sprite.modulate = Color(10,10,10,10)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1,1,1,1)

