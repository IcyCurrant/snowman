extends Node

var playerNode
var RPGplayerNode
var pos : Vector2
var rpg_pos : Vector2
var PlayerHP : float = 75.0
var iFrames : float = 10.0
var completed_levels : Array[bool] = [false, false, false]
var buffs : Dictionary = {}

func _ready() -> void:
	playerNode = get_node_or_null("/root/main_game/player")
	RPGplayerNode = get_node_or_null("/root/level_select_scene/player_rpg")
	
func _process(delta: float) -> void:
	if playerNode:
		pos  = playerNode.global_position
	else:
		pos = Vector2.ZERO
	
	if RPGplayerNode:
		rpg_pos  = RPGplayerNode.global_position
