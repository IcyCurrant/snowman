@tool
extends EditorPlugin

var panel # Panel in Dock
const AUTOLOAD_NAME = "LayerNames" # Autoload Name

func _enter_tree(): # Executes when the plugin is enabled.
	var panel_scene = preload("res://addons/layer_namer/layer_namer_panel.tscn") # Load panel.
	panel = panel_scene.instantiate() # Instantiate panel.
	panel.connect("layers_changed", _on_layers_changed)  # Connect signal "layer changed" to this func.
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, panel) # Add Panel to dock.
	
	# Add Autoload, Godot EditorPlugin boring stuff...
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/layer_namer/layer_names_autoload.gd")

func _exit_tree(): # Executes when the plugin is disabled.
	if panel != null: # If the panel is alive.
		remove_control_from_docks(panel) # Remove it from the dock.
		panel.queue_free() # Delete it from memory.
		panel = null # Make it null.
	
	# Remove Autoload
	remove_autoload_singleton(AUTOLOAD_NAME)

func _on_layers_changed(names): # When layer names change.
	print(names) # Print it into console.
	if Engine.has_singleton("LayerNames"): # If there is an Autoload.
		Engine.get_singleton("LayerNames").load_names() # Load names.
