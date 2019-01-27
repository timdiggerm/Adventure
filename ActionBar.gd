extends HBoxContainer


signal walk
signal look
signal hand

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_WalkButton_pressed():
	emit_signal("walk")


func _on_LookButton_pressed():
	emit_signal("look")


func _on_HandButton_pressed():
	emit_signal("hand")
