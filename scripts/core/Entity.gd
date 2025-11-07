extends Node

class_name Entity

var health: float = 100.0
var max_health: float = 100.0


func take_damage(amount: float):
	var new_health = health - amount
	
	if new_health > 0: # If does not die
		health = new_health
	
	print("Oh nooo! You died!")
	health = 0
	die()
	
func die():
	queue_free()
