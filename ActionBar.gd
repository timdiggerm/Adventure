extends HBoxContainer

signal viewInventory

var message_box
var inventory_box

func _ready():
	inventory_box = get_child(4).get_child(1).get_child(0) as HBoxContainer
	message_box = get_child(4).get_child(1).get_child(1) as RichTextLabel
	theme = Theme.new()
	theme.copy_default_theme()
	populate_inventory()
	
func populate_inventory():
	for n in inventory_box.get_children():
		n.queue_free()

	for obj in global.inventory:
		add_inventory(obj)
		
func add_inventory(obj : AdvThing):
	var itemButton = InventoryButton.new()
	itemButton.item = obj
	itemButton.icon = obj.get_item_texture()
	inventory_box.add_child(itemButton)
	itemButton.connect("pressed", self, 'on_InventoryButton_pressed', [itemButton])

func _on_WalkButton_pressed() -> void:
	global.cursor_state = global.CURSOR_STATES.WALK
	Input.set_default_cursor_shape(Input.CURSOR_MOVE)

func _on_LookButton_pressed() -> void:
	global.cursor_state = global.CURSOR_STATES.LOOK
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)

func _on_HandButton_pressed()  -> void:
	global.cursor_state = global.CURSOR_STATES.HAND
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_TalkButton_pressed():
	global.cursor_state = global.CURSOR_STATES.TALK
	Input.set_default_cursor_shape(Input.CURSOR_IBEAM)

func on_InventoryButton_pressed(itemButton) -> void:
	global.cursor_state = global.CURSOR_STATES.ITEM
	Input.set_custom_mouse_cursor(itemButton.icon, Input.CURSOR_CAN_DROP)
	Input.set_default_cursor_shape(Input.CURSOR_CAN_DROP)
	global.current_item = itemButton.item

func update_text(message):
	message_box.set_text(message)


func _on_SaveButton_pressed():
	print("Prepare to save!")
	global.main_scene.save_game()


func _on_LoadButton_pressed():
	print("Prepare to load!")
	global.main_scene.load_game()


