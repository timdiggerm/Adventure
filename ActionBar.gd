extends HBoxContainer

signal viewInventory

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_WalkButton_pressed() -> void:
	global.cursor_state = global.CURSOR_STATES.WALK


func _on_LookButton_pressed() -> void:
	global.cursor_state = global.CURSOR_STATES.LOOK


func _on_HandButton_pressed()  -> void:
	global.cursor_state = global.CURSOR_STATES.HAND


func _on_InventoryButton_pressed():
	emit_signal("viewInventory")
