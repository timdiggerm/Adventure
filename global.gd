extends Node
var cursor_state
enum CURSOR_STATES {WALK, HAND, LOOK, SMELL, TASTE, LISTEN}
var height = 1000

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	cursor_state = WALK
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
