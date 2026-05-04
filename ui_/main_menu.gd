extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://overworld/level_select_scene.tscn")

func _on_exit_pressed() -> void:
	
	get_tree().quit()
	OS.alert("ok","yes")


func _on_settings_pressed() -> void:
	$CenterContainer/VBoxContainer/settings.text = "not available"
