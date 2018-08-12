extends Label

onready var timer = $"../GameTimer"

signal finished

func _ready():
	timer.start()

func _process(delta):

	if timer.paused:
		return

	var total_seconds_left = int(timer.time_left)

	var minutes_left = total_seconds_left / 60
	var seconds_left = total_seconds_left % 60

	text = "%02d:%02d" % [minutes_left, seconds_left]
