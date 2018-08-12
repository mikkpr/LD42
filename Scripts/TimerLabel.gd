extends Label

var isPaused = false

var time_total_minutes = 4
var time_total_seconds = time_total_minutes * 60

var time_start = 0
var time_now = 0
var finishSignalSent = false

signal finished

func _ready():
	time_start = OS.get_unix_time()
	pass

func _process(delta):
	
	if isPaused:
		return
	
	time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	var elapsed_minutes = elapsed / 60
	var elapsed_seconds = elapsed % 60

	if elapsed_seconds == 0:
		return
	
	var minutes_left = time_total_minutes - elapsed_minutes
	var seconds_left = 60 - elapsed_seconds
	text = "%02d:%02d" % [minutes_left, seconds_left]
	
	if minutes_left == 0 and seconds_left == 1 and !finishSignalSent:
		emit_signal("finished")
		finishSignalSent = true
	
	pass

	
