extends StaticBody2D

@onready var woodText = $"Area2D/CanvasGroup/Wood/Wood Count"
@onready var stoneText = $"Area2D/CanvasGroup/Stone/Stone Count"
@onready var fleshText = $"Area2D/CanvasGroup/Flesh/Flesh Count"

var player

var playerInArea: bool = false
const timeBetweenDepo: float = 0.1
var currentTime: float

var depositedResources = {
	ResourceType.ResourceType.Wood: 0,
	ResourceType.ResourceType.Stone: 0,
	ResourceType.ResourceType.Flesh: 0
}

func _ready():
	UpdateDisplay()

func _process(delta):
	if !playerInArea or player.heldResources.size() <= 0:
		currentTime = 0
		return
	
	currentTime += delta
	if currentTime >= timeBetweenDepo:
		deposit()
		currentTime = 0

func UpdateDisplay():
	woodText.text = "[center]" + str(depositedResources[ResourceType.ResourceType.Wood])
	stoneText.text = "[center]" + str(depositedResources[ResourceType.ResourceType.Stone])
	fleshText.text = "[center]" + str(depositedResources[ResourceType.ResourceType.Flesh])
	

func deposit():
	if player != null:
		#Reduce player resource, increase associated resource
		print("depositing")
		var resource = player.heldResources[player.heldResources.size() - 1]
		depositedResources[resource.resType] += 1
		UpdateDisplay()
		player.DepositResource()
		resource.queue_free()
		pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") and body.heldResources.size() > 0:
		playerInArea = true
		if player == null:
			player = body


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		playerInArea = false
		if player == null:
			player = body
