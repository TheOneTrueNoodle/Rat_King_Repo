extends Control

@onready var panel = $Panel
var open: bool = false

@onready var notification = $"Notif Texture"

func toggleDisplay():
	notification.visible = false
	match open:
		true:
			# Hide display
			open = false
			panel.visible = false
		false:
			# Show display
			open = true
			panel.visible = true

func taskNotif():
	if !open: notification.visible = true
