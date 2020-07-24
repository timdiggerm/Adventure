extends Item

var locked = true
var otherTexture
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init():
	thing_name = "lock"

# Called when the node enters the scene tree for the first time.
func _ready():
	otherTexture = load('res://images/lockUn.png')

func switch_lock():
	locked = not locked
	var sprite = get_child(2)
	var temp = sprite.texture
	sprite.texture = otherTexture
	otherTexture = temp
	
		
func handle_item(item : AdvThing):
	if item.thing_name == "key":
		switch_lock()
