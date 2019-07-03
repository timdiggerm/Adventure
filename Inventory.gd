extends WindowDialog

var grid : GridContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = find_node("InventoryGrid") as GridContainer
	populateInventory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func populateInventory():
	for id in global.inventory:
		var label = Label.new()
		label.set_text(str(id))
		grid.add_child(label)

func _on_Dismiss_pressed():
	hide()
