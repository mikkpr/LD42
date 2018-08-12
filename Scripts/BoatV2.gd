extends Node2D

signal sunk # Emitted when the boat has sunk.

export (float) var degrees_per_tilt = 1.0 # How many degrees to tilt per weight.
export (int) var degrees_to_sink = 90     # At how many degrees to sink.

var tilt = 0.0    # Weighted sum of the Flotsam weights.
var score = 0     # Sum of Flotsam scores.
var active = null # Current active Container.

func _process(delta):
	# TODO: Add better smoothing.
	rotation_degrees += (tilt * degrees_per_tilt - rotation_degrees) / 2 * delta
	if abs(rotation_degrees) > degrees_to_sink:
		emit_signal("sunk")

func store(flotsam):
	if active == null || !active.store(flotsam):
		return false
	tilt += active.coefficient * flotsam.weight
	score += flotsam.score
	return true

func remove():
	if active == null:
		return null
	var flotsam = active.remove()
	if flotsam == null:
		return null
	tilt -= active.coefficient * flotsam.weight
	score -= flotsam.score
	return flotsam

func _activate(container):
	active = container

func _deactivate(container):
	active = null
