extends WindowDialog

var grid : GridContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = find_node("InventoryGrid") as GridContainer
	populate_inventory()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func populate_inventory():
	for n in grid.get_children():
		n.queue_free()

	for obj in global.inventory:
		add_inventory(obj)
		
func add_inventory(obj):
	var item = TextureRect.new()
	item.set_texture(obj.get_child(obj.get_child_count()-1).get_texture())
	grid.add_child(item)

func _on_Dismiss_pressed():
	hide()
