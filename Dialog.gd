extends PopupDialog

var textBox

func _ready():
	textBox = find_node("TextBox")
	#popup()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_DismissBtn_pressed():
	hide()

func displayMessage(message):
	textBox.bbcode_text = message
	popup()