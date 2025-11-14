extends CSGBox3D

@export var item_data: GenericItemData

func _ready():
	add_to_group("pickables")

func on_picked_up():
	print("I was picked up!")
	queue_free()
	
