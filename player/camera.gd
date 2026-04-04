extends Camera2D

var magnitude: float

const MAX_SHAKE_VAL := 5.0

func shake(mag: float):
	magnitude = mag
	# I have no fucking clue why I even did this...but I needed a shake function to call..I can't just use  _process right?/
	
func _process(delta: float) -> void:
	if magnitude > 0:
		magnitude = lerp(magnitude, 0.0, 10 * delta)
		offset = Vector2(randf_range(-1,1), randf_range(-1,1)) * magnitude 
		#change offset by 1 * magintude or in other words just fricking multiply it bruh
