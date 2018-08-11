extends Node

const Networking = preload("Networking.gd") # Relative path

func _ready():

	$UI/TotalLabel.update(400)
	$UI/TimerLabel.connect("finished", self, "on_game_over")
	
	on_game_over()
	
	pass

func on_game_over():

	var instance = Networking.new()
	
	#instance.postScore("test-real", $UI/TotalLabel.get_score())
	#var scores = instance.listScores()