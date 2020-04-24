extends HBoxContainer

signal viewInventory

var message_box

func _ready():
	message_box = get_child(4) as RichTextLabel
	theme = Theme.new()
	theme.copy_default_theme()
	print(theme)
	

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

func update_text(message):
	message_box.set_text(message)
