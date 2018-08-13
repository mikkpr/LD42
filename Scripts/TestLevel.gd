extends Node2D

onready var timer = $UIContainer/UI/GameTimer
onready var scoreboard = $Scoreboard
onready var submitButton = $Scoreboard/UI/MarginContainer/EditContainer/Button
onready var retryButton = $Scoreboard/Retry/UI/MarginContainer/ButtonContainer/Button
onready var menuButton = $Scoreboard/UI/MarginContainer/EditContainer/MenuButton

var isFinished = false

func _ready():
	submitButton.connect("pressed", self, "submit_button_pressed")
	retryButton.connect("pressed", self, "retry_button_pressed")
	menuButton.connect("pressed", self, "menu_button_pressed")

func _process(delta):
	if isFinished:
		return

	var seconds_left = int(timer.time_left)

	if seconds_left == 0:
		_initialize_end_screen(true)

func _initialize_end_screen(isSuccess):
	print("The game is finished, showing end screen")
	if isSuccess:
		$Boat.dock()
	isFinished = true
	scoreboard.show(isSuccess)

func _on_Boat_sunk():
	_initialize_end_screen(false)
	
func retry_button_pressed():
	get_tree().change_scene("res://Scenes/TestLevel.tscn")

func menu_button_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
func submit_button_pressed():
	var score = $UIContainer/UI/TotalLabel.get_score()
	scoreboard.postScore(score)

