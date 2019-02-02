extends HBoxContainer

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_WalkButton_pressed():
	global.cursor_state = global.WALK


func _on_LookButton_pressed():
	global.cursor_state = global.LOOK


func _on_HandButton_pressed():
	global.cursor_state = global.HAND
