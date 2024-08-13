extends Resource

class_name Quirk

@export var Quirk_Name: String
@export var stat: Stat
@export var op: Operation 
@export var value: float

enum Operation {
	ADD, 
	SUBTRACT, 
	MULTIPLY, 
	DIVIDE
}

enum Stat {
	HEALTH,
	SPEED,
	STRENGTH
}
