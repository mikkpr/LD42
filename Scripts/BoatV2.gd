extends Node2D

signal rotation(degrees) # Emitted when the rotation has updated.
signal score(score)      # Emitted when the score has updated.
signal sunk              # Emitted when the boat has sunk.

export (float) var degrees_per_tilt = 1.0 # How many degrees to tilt per weight.
export (int) var degrees_to_sink = 90     # At how many degrees to sink.

var tilt = 0.0    # Weighted sum of the Flotsam weights.
var score = 0     # Sum of Flotsam scores.
var active = null # Current active Container.

func _ready():
	$WheelSplashAudio.play()

func _process(delta):
	# TODO: Add better smoothing.
	rotation_degrees += (tilt * degrees_per_tilt - rotation_degrees) / 2 * delta
	emit_signal("rotation", rotation_degrees)

	update_waterwheel()

	if abs(rotation_degrees) > degrees_to_sink:
		emit_signal("sunk")

func update_waterwheel():
	if rotation_degrees > 5:
		$WheelSplash.hide()
		$WheelSplashAudio.volume_db = -100
	else:
		$WheelSplash.show()
		$WheelSplashAudio.volume_db = 0

func store(flotsam):
	if active == null || !active.store(flotsam):
		print("No active Container" if active == null else "Container full")
		return false
	tilt += active.coefficient * flotsam.weight
	score += flotsam.score
	emit_signal("score", score)
	return true

func remove():
	if active == null:
		return null
	var flotsam = active.remove()
	if flotsam == null:
		return null
	tilt -= active.coefficient * flotsam.weight
	score -= flotsam.score
	emit_signal("score", score)
	return flotsam

func _activate(container):
	print("Activating Container ", container)
	active = container

func _deactivate(container):
	# Only deactivate if container is active, because otherwise things
	# break if we get out-of-order signals (activate A, activate B,
	# deactivate A).
	if active == container:
		print("Deactivating Container ", container)
		active = null
