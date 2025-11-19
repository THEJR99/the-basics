extends Node
class_name Inventory

var BASE_WEIGHT = 1.0

var items = {} # { Rock : 4 }
var current_weight: float = 0.0 # Current weight of the Inventory's Contents.
var carriable_weight = BASE_WEIGHT

signal inventory_contents_changed



@onready var stats_system = $"../Stats"

func _ready():
	stats_system.weight_points_changed.connect(weight_points_changed)

func weight_points_changed(newPoints) -> void:
	var new_total_weight = BASE_WEIGHT + (newPoints*10)
	carriable_weight = new_total_weight
	print("Weight updated! New weight: " + str(new_total_weight))

func pick_up_item(item):
	var item_data: GenericItemData = item.item_data
	var item_name: String = item_data.name
	var quantity: int = item_data.quantity
	var item_weight: float = item_data.weight
	var total_pick_up_weight: float = quantity * item_weight
	
	var valid_weight: bool = weight_added_check(total_pick_up_weight)
	if not valid_weight:
		print("Item is too heavy! Cannot pick up.")
		return
	
	current_weight += total_pick_up_weight
	
	if item_data.name in items:
		items[item_name] += quantity
	else:
		items[item_name] = quantity
	
	print(items)
	
	item.on_picked_up()
	inventory_contents_changed.emit()

func weight_added_check(weight_to_add) -> bool:
	var newWeight = current_weight + weight_to_add
	
	if newWeight > carriable_weight:
		return false
	
	return true

func get_inventory_contents():
	return items
