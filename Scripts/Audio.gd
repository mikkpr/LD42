extends Node

onready var music = $Music
const MAX_PITCH_VARIATION = 0.25

func _on_Boat_rotation(degrees):
	var normalized_degrees = clamp(degrees, -90, 90)
	var pitch_scale = (normalized_degrees / 90) * MAX_PITCH_VARIATION
	music.pitch_scale = 1 + pitch_scale
