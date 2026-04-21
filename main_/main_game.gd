extends Node2D

# --- STORES ALL LEVELS ---
@onready var levels : Array[Node2D] = [
	get_node("/root/main_game/level1"),
	get_node("/root/main_game/level2")
]
#var inactive_levels : Array[Node2D] = []
var current_level : Node2D # STORES CURRENT LEVEL

func _ready() -> void:
	current_level = levels[abs(GameState.level - 1)]
	for level in levels:
		if current_level and current_level != level:
			#inactive_levels.append(level)
			level.visible = false
			level.get_children()[0].collision_enabled = false
			level.get_children()[1].collision_enabled = false
	
func _process(delta: float) -> void:
	current_level.visible = true
	current_level.get_children()[0].collision_enabled = true
	current_level.get_children()[1].collision_enabled = true
