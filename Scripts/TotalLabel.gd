extends Label

var score = 0

func update(score):
	text = "Score: " + str(score)

func get_score():
	return score;