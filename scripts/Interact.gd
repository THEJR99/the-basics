extends Node

@onready var character = $".."
@onready var head = $"../Head"
@onready var camera = $"../Head/Camera3D"

var interaction_range = 2.5

#func _ready():
	#await get_tree().create_timer(10.0).timeout


func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("interact"): # E
			handle_interaction_key_press()

func handle_interaction_key_press():
	var origin = camera.global_position
	var direction = -camera.global_transform.basis.z.normalized()
	var endPosition = origin + direction * interaction_range
	var exclude = [character]
	
	var result = await raycast_basic(origin, endPosition, exclude)
	
	if not result:
		print("Nothing was hit...")
	else:
		print(result["collider"].name)
	
	
	debug_ray(origin, endPosition)

func raycast_basic(origin, end, exclude_list):
	await get_tree().physics_frame # Yeilds for physics step to then run
	var space_state = get_viewport().world_3d.direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = exclude_list
	var result = space_state.intersect_ray(query)
	return result

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
