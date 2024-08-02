extends Node2D

@export var spawnable_enemies: Array[PackedScene]

@export var minTimeToSpawn: int = 10
@export var maxTimeToSpawn: int = 30
var currentTime

func _ready():
	#Set starting spawn time!
	currentTime = randi_range(minTimeToSpawn, maxTimeToSpawn)

func _process(delta):
	currentTime -= delta
	if currentTime <= 0:
		Spawn()

func Spawn():
	#Debug
	print("spawning")
	#Choose enemy to spawn
	var enemyID = randi_range(0, spawnable_enemies.size()-1)
	var newEnemy = spawnable_enemies[enemyID].instantiate()
	newEnemy.global_position = global_position
	get_tree().root.add_child(newEnemy)
	
	#Reset Timer
	currentTime = randi_range(minTimeToSpawn, maxTimeToSpawn)
