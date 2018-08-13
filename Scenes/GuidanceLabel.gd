extends Label

var tips = [ # TODO: Actually funny puns, actually useful tips
	"Tip: Netting a beaut might net more than she's worth",
	"Tip: Offishially, juggling fish between containers ain't allowed. Everyone does it.",
	"Tip: How do you know how much a fish weighs? By the scales!",
	"Tip: A healthy dose of vitamin sea keeps the scurvy at bay",
	"Tip: Excuse my resting beach face",
	"Tip: Don’t be salty, try again!",
	"Tip: What a fin-tastic day",
	"Tip: Lost at sea? I’m not shore",
	"Tip: Mermaids in brine are a delicacy in some parts of the world",
	"Tip: You did that on porpoise, didn’t you?",
	"Tip: There’s a guardian angler for everyone",
	"Tip: Many a sailor turns to drugs due to pier pressure",
	"Tip: It might take a whale to get the hang of it, don’t give up",
	"Tip: You flotsam, you lose some"
	]

func _ready():
	randomize()

func randomTip():
	text = tips[randi() % tips.size()]