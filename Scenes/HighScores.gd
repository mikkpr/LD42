extends Node

onready var ScoreRow = preload("res://Scenes/HighScoreRow.tscn")
onready var scoresContainer = $MarginContainer/Scores
onready var networking = $Networking

func _ready():
	var scoreValues = networking.listScores()
	var maxScores = 5

	for i in range(clamp(scoreValues.size(), 0, maxScores)):
		var score = scoreValues[i]
		var nickname = score.nickname
		var value = score.score
		var scoreRow = ScoreRow.instance()

		scoreRow.find_node("Nickname").text = nickname
		scoreRow.find_node("Score").text = value
		scoresContainer.add_child(scoreRow)

func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
