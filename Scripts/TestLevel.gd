extends Node2D

onready var timer = $UIContainer/UI/GameTimer
onready var scoreboard = $Scoreboard
onready var button = $Scoreboard/UI/MarginContainer/EditContainer/Button

var isFinished = false

func _ready():

	button.connect("pressed", self, "button_pressed")

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



func button_pressed():
	print("button_pressed")
	var score = $UIContainer/UI/TotalLabel.get_score()
	scoreboard.postScore(score)



