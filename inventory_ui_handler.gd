extends Control

@onready var inventory = $"../Inventory"

func _ready():
	inventory.inventory_contents_changed.connect(inventory_items_update)

	print("Waiting 3 seconds to disable!")
	await get_tree().create_timer(3.0).timeout
	visible = false

func inventory_items_update():
	print("The inventory changed!")
	return

func update_items():
	return

func toggle_ui(turn_on: bool):
	if visible == turn_on:
		print("already set to that state!")
		return
	
	visible = not visible
