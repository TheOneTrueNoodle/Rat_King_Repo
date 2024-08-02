extends Node2D

#Spawnable enemy types
@export var spawnable_enemies: Array[PackedScene]

#Spawn area
@onready var spawnArea = $"Spawn Area"

#Time to spawn
@export var minTimeToSpawn: int = 8
@export var maxTimeToSpawn: int = 15
var currentTime

#Enemy count 
@export var min_enemy_count: int = 1
@export var max_enemy_count: int = 3
var enemyCount
var spawnedEnemies = 0

func _ready():
	#Set starting spawn time!
	currentTime = randi_range(minTimeToSpawn, maxTimeToSpawn)
	enemyCount = randi_range(min_enemy_count, max_enemy_count)

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
	get_tree().root.add_child(newEnemy)
	
	newEnemy.global_position = global_position
	spawnedEnemies += 1
	
	#Reset Timer
	if spawnedEnemies < enemyCount:
		currentTime = randi_range(minTimeToSpawn, maxTimeToSpawn)
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
