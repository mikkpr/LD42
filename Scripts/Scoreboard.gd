extends Node

onready var ScoreRow = preload("res://Scenes/HighScoreRow.tscn")
onready var scoresContainer = $UI/MarginContainer/Scores
onready var networking = $Networking

func _ready():
	$UI/MarginContainer/Scores/Loading.visible = false
	$UI/MarginContainer/PositionLabel.visible = false
	$UI/MarginContainer/Label.text = "Enter your nickname"

	networking.connect("load_complete", self, "load_complete")

	pass

func _process(delta):
	$UI/MarginContainer/Label.margin_top = 10
	pass
	
func show(isSuccess):
	if isSuccess:
		$UI.show()
	else:
		$Retry/UI.show()

func postScore(score):
	$UI/MarginContainer/Scores/Loading.visible = true
	$UI/MarginContainer/Label.visible = false
	$UI/MarginContainer/EditContainer.visible = false
	
	var nickname = $UI/MarginContainer/EditContainer/TextEdit.text
	networking.post_score_async(nickname, score)

func load_complete(json):

	$UI/MarginContainer/Scores/Loading.visible = false
	$UI/MarginContainer/Label.visible = true
	$UI/MarginContainer/Label.text = "TOP SCORES"

	var scores = json.top
	for i in range(scores.size()):

		var score = scores[i]
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
		
	$UI/MarginContainer/PositionLabel.visible = true
	$UI/MarginContainer/PositionLabel.text = "Your position: " + str(json.position)
	
	$UI/MarginContainer/EditContainer.visible = true
	$UI/MarginContainer/EditContainer/Button.visible = false
	$UI/MarginContainer/EditContainer/TextEdit.visible = false
	
	$UI/MarginContainer/EditContainer/MenuButton.visible = true





