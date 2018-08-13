extends Label

var score = 0

func _ready():
	update(0)

func update(score):
	self.score = score
	text = "Score: " + str(score)

func get_score():
	return score;