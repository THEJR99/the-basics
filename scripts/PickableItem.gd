extends CSGBox3D

@export var item_data: ItemData

func _ready():
	add_to_group("pickables")

func on_picked_up():
	queue_free()
	
