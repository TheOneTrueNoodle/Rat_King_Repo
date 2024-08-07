extends Control

signal taskComplete

var dayCount: int = 0

@onready var taskNameDisp = $"Task Name"
@onready var daysRemainingDisp = $"Days remaining"

func setup(requiredDays: int, taskName: String):
	dayCount = requiredDays
	DayManager.dayPassed.connect(dayPassed)
	
	# Set task display
	taskNameDisp.text = taskName

	var _dayText: String = " days"
	if(dayCount > 1): _dayText = " day"
	daysRemainingDisp.text = str(dayCount) + _dayText

func dayPassed():
	dayCount -= 1
	
	# Update task display
	var _dayText: String = " days"
	if(dayCount > 1): _dayText = " day"
	daysRemainingDisp.text = str(dayCount) + _dayText
	
	if dayCount <= 0:
		taskComplete.emit()
		
		for connection in taskComplete.get_connections():
			taskComplete.disconnect(connection["callable"])
		
		queue_free()
	
