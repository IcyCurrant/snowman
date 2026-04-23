extends Node2D

# --- STORES ALL LEVELS ---
@onready var levels : Array[Node2D] = [
	get_node("/root/main_game/level1"),
	get_node("/root/main_game/level2")
]
#var inactive_levels : Array[Node2D] = []
var current_level : Node2D # STORES CURRENT LEVaEL

var end_pos
var level #reference to the main colliding blocks
var hurtboxes #reference to the main hurtboxes

func _ready() -> void:
	current_level = levels[abs(GameState.level - 1)]
	
	# CODE BELOW MAKES ALL OTHER LEVEL NODES INACTIVE
	for level_ in levels:
		if current_level and current_level != level_:
			#inactive_levels.append(level)
			level_.visible = false
			level_.get_children()[0].collision_enabled = false
			level_.get_children()[1].collision_enabled = false
			
	level = current_level.get_children()[0] # main level tilemap
	hurtboxes = current_level.get_children()[1] # ow...
	
	#print(level.get_used_cells_by_id(0,Vector2i(0,2))) # FOR DEBUGGING PURPOSES
	
	# basically....find the global position of a given tile x whose atlast is (0,2)
	# or....level.map_to_local(level.find_cell_at(0,2)_and_give_its_id)
	if level.get_used_cells_by_id(0,Vector2i(0,2)).is_empty():
		end_pos = Vector2i.ZERO
	else:
		end_pos = level.map_to_local(level.get_used_cells_by_id(0,Vector2i(0,2))[0]) #returns an array so we need only one element which is [0]]
	$Sprite2D.global_position = end_pos

func _process(_delta: float) -> void:
	
	current_level.visible = true
	level.collision_enabled = true
	hurtboxes.collision_enabled = true
