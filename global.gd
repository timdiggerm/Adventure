extends Node
enum CURSOR_STATES {WALK, HAND, LOOK, SMELL, TASTE, LISTEN}
var cursor_state
var height = 1000
var scaleFactor = 0

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	cursor_state = global.CURSOR_STATES.WALK
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
