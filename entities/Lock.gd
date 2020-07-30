extends Item

var locked = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init():
	thing_name = "lock"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func switch_lock():
	locked = not locked
	var sprite = get_child(2) as AnimatedSprite
	sprite.set_frame((sprite.get_frame() + 1) % 2)
	
		
func handle_item(item : AdvThing):
	if item.thing_name == "key":
		switch_lock()
