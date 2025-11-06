extends Node
class_name Inventory

var items = {} # [ {} ]
var t = { "Fuck": 123 }
var weight: float = 0.0 # Current weight of the Inventory's Contents.
var carriable_weight = 10.0

func add_item(item: ItemData) -> bool:
	var newWeight = weight + item.weight
	
	if newWeight > carriable_weight:
		print("Cannot pick up this item! You're holding too much weight!")
		return false
	
	weight = newWeight
	var itemQuantity = items[item.name]
	print("Picking up new item: " + item.name)
	
	if not itemQuantity:
		items[item.name] = 1
	else:
		items[item.name] += 1 
		
	print("New quantity of " + item.name + "is " + str(items[item.name]) )
	
	return true
