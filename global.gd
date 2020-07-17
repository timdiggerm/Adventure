extends Node
enum CURSOR_STATES {WALK, HAND, LOOK, SMELL, TASTE, LISTEN, ITEM}
var cursor_state
var height = 1000
var scaleFactor = 0
var idGenerator : RandomNumberGenerator
var playerWidthHalf = 30
var inventory = []
var locales = {}
var scenes = {}
var main_scene

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	Input.set_custom_mouse_cursor(load('res://images/hollowEye.png'), Input.CURSOR_CROSS, Vector2(25,25))
	Input.set_custom_mouse_cursor(load('res://images/arrowCursor.png'), Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(load('res://images/handBlank.png'), Input.CURSOR_POINTING_HAND, Vector2(18,5))
	Input.set_custom_mouse_cursor(load('res://images/walkBlank.png'), Input.CURSOR_MOVE, Vector2(4,41))
	
	cursor_state = global.CURSOR_STATES.WALK
	idGenerator = RandomNumberGenerator.new()
	idGenerator.set_seed(0)
	
	
	#idGenerator.randomize()
#	inventory.append(nextId())
#	inventory.append(nextId())
#	inventory.append(nextId())

func nextId() -> int:
	return idGenerator.randi()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
