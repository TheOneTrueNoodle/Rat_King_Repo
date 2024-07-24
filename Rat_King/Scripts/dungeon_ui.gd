extends CanvasLayer

#Gas Timer Variables
@export var gasTimer: GasTimer

#Player
@export var hpBar: PlayerHPBar
var playerNode: Player

func dungeon_loaded():
	gasTimer.startTimer() #Can pass in more variables here when generating dungeon
	playerNode = get_tree().get_first_node_in_group("Player")
	hpBar.setup(playerNode)
