extends Node
class_name Inventory

var BASE_WEIGHT = 10

var items = {} # Rock : 4
var t = { "Fuck": 123 }
var current_weight: float = 0.0 # Current weight of the Inventory's Contents.
var carriable_weight = BASE_WEIGHT



@onready var stats_system = $"../Stats"

func _ready():
	stats_system.weight_points_changed.connect(weight_points_changed)

func weight_points_changed(newPoints) -> void:
	var new_total_weight = BASE_WEIGHT + (newPoints*10)
	carriable_weight = new_total_weight
	print("Weight updated! New weight: " + str(new_total_weight))

func pick_up_item(item):
	
	var item_data: ItemData = item.item_data
	var quantity = item_data.quantity
	var item_weight = item_data.weight
	var weight_to_pick_up = quantity * item_weight
	
	print(item)

func weight_added_check(weight_to_add):
	var newWeight = current_weight + weight_to_add
	
	if newWeight > carriable_weight:
		print("Cannot pick up this item! You're holding too much weight!")
		return false
	
	return true

func add_item(item: ItemData) -> bool:
	var newWeight = current_weight + item.weight
	
	if newWeight > carriable_weight:
		print("Cannot pick up this item! You're holding too much weight!")
		return false
	
	current_weight = newWeight
	var itemQuantity = items[item.name]
	print("Picking up new item: " + item.name)
	
	if not itemQuantity:
		items[item.name] = 1
	else:
		items[item.name] += 1 
		
	print("New quantity of " + item.name + "is " + str(items[item.name]) )
	
	return true
