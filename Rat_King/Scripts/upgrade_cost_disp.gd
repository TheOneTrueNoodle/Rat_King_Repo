extends Control

@onready var textDisp = $RichTextLabel
@onready var visuals = $AnimatedSprite2D

func setup(newValue: int, newType: String):
	textDisp.text = str(newValue)
	
	match newType:
		"Wood":
			visuals.frame = 0
		"Stone":
			visuals.frame = 1
		"Metal":
			visuals.frame = 2
		"Medicine":
			visuals.frame = 3
		"Food":
			visuals.frame = 4
	
