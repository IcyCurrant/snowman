# Godot Layer Namer

A Godot 4 plugin that lets you name your collision and render layers, 
inspired by Unity's layer system. Instead of remembering which number 
corresponds to which layer, just use names directly in your code.

![LayerNamer](https://github.com/user-attachments/assets/1214c07f-8298-4d4a-8417-3cae898b56da)

## The Problem
In Godot, layers are just numbers:
collision_mask = 4 # What is layer 4 again...?

## The Solution
With Layer Namer you can do this:
collision_mask = LayerNames.get_mask("Enemies")

## Features
- Name up to 32 layers from the editor panel
- Names persist across sessions
- Access layers by name in any script via the LayerNames autoload
- Lightweight, no dependencies

## Installation
1. Download or clone this repository
2. Copy the `addons/layer_namer` folder into your project's `addons/` folder
3. Go to `Project → Project Settings → Plugins`
4. Enable **Layer Namer**

## Usage

### Naming your layers
After enabling the plugin, open the **Layer Namer** panel in the bottom-right dock and assign names to your layers.

### Using layer names in code
```gdscript
# Get the layer number by name
var layer = LayerNames.get_layer("Enemies")  # returns 1, 2, 3...

# Get the bitmask directly for collision_mask
collision_mask = LayerNames.get_mask("Enemies")

# Get the name of a layer by its number
var name = LayerNames.get_layer_name(1)
```

## Compatibility
- Godot 4.x
- GDScript

## License
MIT License
