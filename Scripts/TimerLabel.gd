extends Label

onready var timer = $"../GameTimer"


var isPaused = false

var time_start = 0

signal finished

func _ready():
	time_start = timer.time_left
	timer.start()

func _process(delta):
	timer.paused = isPaused

	if timer.paused:
		return

	var time_now = timer.time_left
	var total_seconds_left = int(time_now) - int(time_start)

	var minutes_left = total_seconds_left / 60
	var seconds_left = total_seconds_left % 60

	text = "%02d:%02d" % [minutes_left, seconds_left]


func _on_GameTimer_timeout():
	isPaused = true
