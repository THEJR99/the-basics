extends Node3D
class_name Stats

var weight_points = 0
var health_points = 0
var speed_points = 0
var technical_points = 0 # Crafting speed

signal health_points_changed
signal weight_points_changed

func _ready():
	health_points = 1
	weight_points = 1
	health_points_changed.emit(health_points)
	weight_points_changed.emit(weight_points)
