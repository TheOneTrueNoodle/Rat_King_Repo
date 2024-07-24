extends Control
class_name GasTimer

var started: bool = false

@export var totalTime: float
@export var gasBar: VSlider
var remainingTime: float

var timerSpeed = 1

func _process(delta):
	if !started:
		return
		
	remainingTime -= delta * timerSpeed
	gasBar.value = remainingTime
	
	if remainingTime <= 0:
		#Time has run out, game over
		get_tree().quit()

func startTimer():
	remainingTime = totalTime
	started = true

func speed_up_timer():
	timerSpeed = 2

func reset_timer_speed():
	timerSpeed = 1

func reduce_remaining_time(amount):
	remainingTime -= amount
