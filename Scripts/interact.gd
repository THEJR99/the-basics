extends Node

@onready var head = $"../Head"
@onready var camera = $"../Head/Camera3D"

func _ready():
	var leftRight = head.transform.basis.get_euler().y
	var upDown = camera.rotation.x
	await get_tree().create_timer(10.0).timeout
	print("X-Movement Cordinate: " + str(leftRight))
	print("Y-Movement Cordinate: " + str(upDown))


func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("interact"):
			print("Pressed E!")
			var origin = camera.global_position
			var direction = -camera.global_transform.basis.z.normalized()
			var length = 5
			
			var endPosition = origin + direction * length
			debug_ray(origin, endPosition)


func debug_ray(origin: Vector3, end: Vector3):
	var start_sphere = create_debug_sphere(origin, Color.RED)
	var end_sphere = create_debug_sphere(end, Color.GREEN)
	
	# Auto-remove after a short delay (e.g. 1 second)
	await get_tree().create_timer(2.5).timeout
	start_sphere.queue_free()
	end_sphere.queue_free()


func create_debug_sphere(position: Vector3, color: Color) -> MeshInstance3D:
	var sphere = MeshInstance3D.new()
	sphere.mesh = SphereMesh.new()
	sphere.mesh.radius = 0.1  # small debug sphere
	sphere.material_override = StandardMaterial3D.new()
	sphere.material_override.albedo_color = color
	sphere.global_position = position
	get_node("../../").add_child(sphere)  # add to current scene or world node
	return sphere
