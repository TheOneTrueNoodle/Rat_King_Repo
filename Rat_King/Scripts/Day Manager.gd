extends Node2D

var currentDay = 0

@onready var dayTimer = $Timer
@onready var dayDisp = $"CanvasLayer/Day Timer UI/Panel/RichTextLabel"

signal dayPassed

func _ready():
	updateDayDisplay() 

func startTimer():
	dayTimer.start()

func pauseTimer():
	dayTimer.stop()

func nextDay():
	#Increase current day count and update display
	currentDay += 1
	dayPassed.emit()
	updateDayDisplay()
	
	# Count down days on any active tasks!
	
	# Reset timer to continue timer UNLESS a task completed! Then pause.
	startTimer()

func updateDayDisplay():
	dayDisp.text = "[center] Day " + str(currentDay) + "[/center]"
