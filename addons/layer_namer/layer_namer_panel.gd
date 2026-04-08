@tool
extends Control

signal layers_changed(names) # Signal when layers change.

var layer_names = {} # Array with layer names.
var inputs = [] # Inputs of layer names.
const SAVE_PATH = "res://addons/layer_namer/layer_names.cfg"

func _ready():
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT) # Set dock anchor.
	
	load_names() # Load last session names.
	
	var scroll = ScrollContainer.new() # Create a scroll container.
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT) # Set scroll container anchor.
	add_child(scroll) # Add scroll as child of the control node.
	
	var vbox = VBoxContainer.new() # Create a vertical box.
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL # Expand vertical box.
	scroll.add_child(vbox) # Make scroll container child of the vertical box.
	
	var title = Label.new() # Create a label.
	title.text = "Layer Names" # Set text.
	vbox.add_child(title) # Make it child of the vertical box.
	
	for i in range(32): # For every layer-bit, 32 in total...
		var hbox = HBoxContainer.new() # Add an horizontal box.
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL # Expand it.
		vbox.add_child(hbox) # Make it child of the vertical box.
		
		var label = Label.new() # Create a label.
		label.text = "Layer %d" % (i + 1) # Set text to its respective layer id.
		label.custom_minimum_size.x = 60 # Set text minimum size.
		hbox.add_child(label) # Make it child of the horizontal box.
		
		var input = LineEdit.new() # Create an editable text.
		input.placeholder_text = "Unnamed" # Make placeholder text "Unamed" in case layer is unnamed.
		input.size_flags_horizontal = Control.SIZE_EXPAND_FILL # Expand editable text.
		input.text = layer_names.get(i, "") # Default value of layer name is empty.
		input.connect("text_changed", _on_name_changed.bind(i)) # Connect the signal when the text is edited to this func.
		hbox.add_child(input) # Make it child of the horizontal box.
		inputs.append(input) # Add it to the inputs variable array.

func _on_name_changed(new_text: String, index: int): # When a layer name is changed.
	layer_names[index] = new_text # The array with layer names saves the new name.
	save_names() # Saves names in the project.
	emit_signal("layers_changed", layer_names) # Emits signal that the layer changed.

func save_names(): # Saves names in a config file.
	var config = ConfigFile.new()
	for i in layer_names:
		config.set_value("layers", str(i), layer_names[i])
	config.save(SAVE_PATH)

func load_names(): # Loads names from the config file.
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		for key in config.get_section_keys("layers"):
			layer_names[int(key)] = config.get_value("layers", key)
