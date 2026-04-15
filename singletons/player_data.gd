extends Node

var playerNode
var pos : Vector2
var PlayerHP : float = 75.0
var iFrames : float = 10.0
var buffs : Dictionary = {}

func _ready() -> void:
	playerNode = get_node_or_null("/root/main_game/player")
	
func _process(delta: float) -> void:
	if playerNode:
		pos  = playerNode.global_position
	else:
		pos = Vector2.ZERO
