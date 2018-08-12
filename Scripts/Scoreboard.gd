extends Node

onready var ScoreRow = preload("res://Scenes/HighScoreRow.tscn")
onready var scoresContainer = $UI/MarginContainer/Scores
onready var networking = $Networking

func _ready():
	$UI/MarginContainer/Scores/Loading.visible = false
	networking.connect("load_complete", self, "load_complete")
	pass

func show():
	$UI.show()

func postScore(score):
	$UI/MarginContainer/Scores/Loading.visible = true
	
	var nickname = $UI/MarginContainer/EditContainer/TextEdit.text
	networking.post_score_async(nickname, score)
		
func load_complete(json):
	
	$UI/MarginContainer/Scores/Loading.visible = false

	print("load_complete")
	
	#print("Top size: " + str(json.top.size()))
	#print("Top: " + str(json.top))
	
	var scores = json.top
	for i in range(scores):
		print(str("in_loop"))
		var score = scores[i]

		var nickname = score.nickname
		var value = score.score
		var scoreRow = ScoreRow.instance()

		if nickname == null:
			nickname = ""

		if value == null:
			value = "0"
		
		print("Nickname: " + nickname + "; Score: " + score)
		scoreRow.find_node("Nickname").text = nickname
		scoreRow.find_node("Score").text = value
		scoresContainer.add_child(scoreRow)
		
		
		
