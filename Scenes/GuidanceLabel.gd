extends Label

var tips = [ # TODO: Actually funny puns, actually useful tips
	"Tip: Netting a beaut might net more than she's worth",
	"Tip: Offishially, juggling fish between containers ain't allowed. Everyone does it.",
	"Tip: How do you know how much a fish weighs? By the scales!"
	]

func _ready():
	randomize()

func randomTip():
	text = tips[randi() % tips.size()]