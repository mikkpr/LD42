extends Node2D

onready var timer = $UIContainer/UI/GameTimer
onready var scoreboard = $Scoreboard
onready var submitButton = $Scoreboard/UI/MarginContainer/EditContainer/Button
onready var retryButton = $Scoreboard/RetryUI/MarginContainer/ButtonContainer/Button

var isFinished = false

func _ready():
	submitButton.connect("pressed", self, "submit_button_pressed")
	retryButton.connect("pressed", self, "retry_button_pressed")

func _process(delta):
	if isFinished:
		return

	var seconds_left = int(timer.time_left)

	if seconds_left == 0:
		_initialize_end_screen(true)

func _initialize_end_screen(isSuccess):
	print("The game is finished, showing end screen")
	isFinished = true
	scoreboard.show(isSuccess)

func _on_Boat_sunk():
	_initialize_end_screen(false)
	
func retry_button_pressed():
	print("TODO")
	
func submit_button_pressed():
	var score = $UIContainer/UI/TotalLabel.get_score()
	scoreboard.postScore(score)

