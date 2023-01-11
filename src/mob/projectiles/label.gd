extends Label

var texts = ["Fakta", "Dukun", "Trik", "meme", "Mixue", "Bing Chilling", "Kamu nanya?"] # Add your texts here

func _ready():
	var random_index = randi() % texts.size()
	text = texts[random_index]
