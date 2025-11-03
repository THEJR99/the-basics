extends Node

@onready var head = $"../Head"
@onready var camera = $"../Head/Camera3D"

func _ready():
	var leftRight = head.transform.basis.get_euler().y
	var upDown = camera.rotation.x
	await get_tree().create_timer(10.0).timeout
	print("X-Movement Cordinate: " + str(leftRight))
	print("Y-Movement Cordinate: " + str(upDown))
