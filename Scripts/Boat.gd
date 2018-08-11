extends Node2D

export (float) var degreesPerTilt  # How many degrees to tilt per weight.
export (int) var degreesToSink  # At how many degrees to sink.

signal picked_up(flotsam)  # Sent when a piece of flotsam is picked up.
signal sunk  # Sent when the boat has sunk.

func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and ev.pressed:
		var flotsam = $Cargo.pickup(ev.position)
		if flotsam != null:
			emit_signal("picked_up", flotsam)

func _process(delta):
	# TODO: Add smoothing.
	rotation_degrees = degreesPerTilt * $Cargo.tilt
	if abs(rotation_degrees) > degreesToSink:
		emit_signal("sunk")
