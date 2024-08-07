extends Node2D

signal taskComplete

var dayCount: int = 0

func setup(requiredDays):
	dayCount = requiredDays
	DayManager.dayPassed.connect(dayPassed)

func dayPassed():
	dayCount -= 1
	if dayCount <= 0:
		taskComplete.emit()
		
		for connection in taskComplete.get_connections():
			taskComplete.disconnect(connection["callable"])
		
		queue_free()
	
