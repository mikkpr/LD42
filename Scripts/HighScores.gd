extends Node

onready var ScoreRow = preload("res://Scenes/HighScoreRow.tscn")
onready var scoresContainer = $UI/MarginContainer/Scores
onready var networking = $Networking

func _ready():
	
	networking.connect("load_complete", self, "load_complete")
	networking.list_scores_async()

func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func load_complete(json):

	for i in range(json.size()):
		var score = json[i]
		var nickname = score.nickname
		var value = score.score
		var scoreRow = ScoreRow.instance()
		
		if nickname == null:
			nickname = ""
		
		if value == null:
			value = "0"
		
		scoreRow.find_node("Nickname").text = nickname
		scoreRow.find_node("Score").text = value
		scoresContainer.add_child(scoreRow)
	
	









