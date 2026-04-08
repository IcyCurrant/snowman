extends Node

const SAVE_PATH = "res://addons/layer_namer/layer_names.cfg"

var layer_names = {} # Array of layer names.

func _ready():
	load_names() # Load names.

func load_names(): # Load names from the config file.
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		for key in config.get_section_keys("layers"):
			layer_names[int(key)] = config.get_value("layers", key)

# CODING FUNCS / UTILITIES
func get_layer(name: String) -> int: # Returns the layer index by name.
	for index in layer_names:
		if layer_names[index] == name:
			return index + 1  # Godot layers start with 1
	push_error("LayerNames: layer '%s' no encontrado" % name)
	return -1

func get_mask(name: String) -> int:
	# Returns bitmask to use with collision_mask
	var index = get_layer(name)
	if index == -1:
		return 0
	return 1 << (index - 1)

func get_layer_name(index: int) -> String: # Returns the name of a layer with index.
	return layer_names.get(index - 1, "Layer %d" % index)
