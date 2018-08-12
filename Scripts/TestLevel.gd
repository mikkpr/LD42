extends Node2D

onready var timer = $UIContainer/UI/GameTimer
onready var scoreboard = $Scoreboard

var isFinished = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here

	pass

func _process(delta):

	if isFinished:
		return
	
	var seconds_left = int(timer.time_left)
	
	if seconds_left == 0:
		_initialize_end_screen()
	
	pass

func _initialize_end_screen():
	print("The game is finished, showing end screen")
	isFinished = true
	scoreboard.show()
