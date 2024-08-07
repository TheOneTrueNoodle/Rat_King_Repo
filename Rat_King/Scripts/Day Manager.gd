extends Node2D

var currentDay = 0

# Visuals
@onready var canvas = $CanvasLayer
@onready var dayDisp = $"CanvasLayer/Day Timer UI/Panel/RichTextLabel"

# Timer Variables
@onready var dayTimer = $Timer

# Task Variables
@onready var taskParent = $"Task Holder"
@export var task: PackedScene

signal dayPassed

func _ready():
	updateDayDisplay() 

func startTimer():
	dayTimer.start()

func pauseTimer():
	dayTimer.stop()

func startTask(function, requiredDays):
	var newTask = task.instantiate()
	taskParent.add_child(newTask)
	newTask.taskComplete.connect(function)
	newTask.setup(requiredDays)
	pass

func nextDay():
	#Increase current day count and update display
	currentDay += 1
	updateDayDisplay()
	
	# Count down days on any active tasks!
	dayPassed.emit()
	
	# Reset timer to continue timer UNLESS a task completed! Then pause.
	startTimer()

func updateDayDisplay():
	dayDisp.text = "[center] Day " + str(currentDay) + "[/center]"

func hideDisplay():
	canvas.visible = false

func showDisplay():
	canvas.visible = true
