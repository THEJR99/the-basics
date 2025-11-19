extends Control

@export var item_slot_scene: PackedScene
@onready var inventory = $"../Inventory"

var current_inventory_ui_items = 0

func _ready():
	inventory.inventory_contents_changed.connect(inventory_items_update)

	print("Waiting 3 seconds to disable!")
	await get_tree().create_timer(3.0).timeout
	visible = false

func create_ui_slot():
	return item_slot_scene.instantiate()

func inventory_items_update():
	print("The inventory changed!")
	var new_contents = inventory.get_inventory_contents()
	
	for index in new_contents:
		print()
	
	return

func update_items():
	return

func toggle_ui():
	visible = not visible
