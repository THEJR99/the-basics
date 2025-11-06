extends Node

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.004

# Movement Speed Variables
var weight_util_to_weighdown: float = 0.9 # Once 90% weight, remaining 10% slows you down until you dont move at all

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var head = $"../Head" # Waits for instance to enter scene to set variable
@onready var camera = $"../Head/Camera3D" # x2
@onready var character_body = $".."

@onready var inventory = $"../Inventory"

func _ready(): # Runs when the node and its children load into the scene (Equivolent to :WaitForChild() and all its children )
	print("Started")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Locks mouse to center invisibly

func _unhandled_input(event: InputEvent): # Kinda like UIS, but rather than connecting actions, you find them as they occur
	if event is InputEventMouseMotion: # Checks if `event` is the same instance as `InputEventMouseMotion`. (if "hi" is "hi" == false)
		var xMouseMovement = -event.relative.x * SENSITIVITY # The amount of mouse pixels moved left or right from last frame
		
		
		#print("Moving Y-Axis __ Degree:\n" + str(event.relative.x * SENSITIVITY))
		var yMouseInput = -event.screen_relative.y * SENSITIVITY # Get mouse input and scale it via sens
		var newCameraRotation = camera.transform.basis.get_euler().x + yMouseInput # Create variable with new mouse movement added to previous camera x
		var clampedCameraRotation =  clamp(newCameraRotation, deg_to_rad(-40), deg_to_rad(60)) # Clamp the value to stop looking too far up or down
		
		head.rotate_y(xMouseMovement)
		
		
		#camera.rotation.x = clampedCameraRotation
		camera.transform.basis = Basis().rotated(Vector3.RIGHT, clampedCameraRotation)
		#camera.transform.basis.x = Vector3(1,1,1)
		#camera.transform.basis *= Basis().rotated(Vector3.RIGHT, deg_to_rad(clampedCameraRotation))
		
		
		#basis = basis.rotated(Vector3.RIGHT, yMouseInput)
		
		#camera.transform.basis *= basis
		
		
func _physics_process(delta):
	# Gravity Hanlder
	var on_floor = character_body.is_on_floor()
	if not on_floor: # Internally checks collider's normal + slope angle to detemine if is floor.
		character_body.velocity.y -= gravity * delta # Gets graviry and multiplies it by delta, then applies it to CharacterBody3D velocity
		
	# Jump Hanlder
	var jumpKeyPressed = Input.is_action_just_pressed("jump") # Gets jump key via Project > Project Settings > Input Map
	if jumpKeyPressed and on_floor:
		character_body.velocity.y = JUMP_VELOCITY # Immediately sets CharacterBody3D Velocity to max jump velocity, which throws character up, then gravity pulls down
		
	# Handle Sprint.
	var sprintKeyHeld = Input.is_action_pressed("sprint") # Gets sprint key via Project > Project Settings > Input Map
	var weightSlowdown = weight_util_to_weighdown
	var currentWeight = inventory.weight
	if sprintKeyHeld: # Set variable to be used elsewhere
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down") # Basically is_action_pressed x4, then outputs Vector2 of the inputs

	# Gets the 'CFrame.Angles of head and transform'(transform never rotates, so always 1 or 0)
	# Multiplies x and y into x and z cordinate, which remains the same since ONLY y is being updated in head
	# Normalize this combined vector, which then gives the seemingly useless calculcation direction.
	# Applies the velocity accordingly
	#print(camera.global_position)
	var direction = (head.transform.basis * character_body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if on_floor:
		if direction: # If direction is ~= Vector3.ZERO
			character_body.velocity.x = direction.x * speed
			character_body.velocity.z = direction.z * speed
		else: # When key is not pressed | Smooth stop
			var slowdownSpeed = 7.0
			# lerp (current speed | to 0.0 (cus not direction:) | at a rate of delta * slowdownSpeed)
			character_body.velocity.x = lerp(character_body.velocity.x, 0.0, delta * slowdownSpeed)
			character_body.velocity.z = lerp(character_body.velocity.z, 0.0, delta * slowdownSpeed)
	else: # When falling
		
		# lerp (current speed | to direction at speed | at a rate of delta * slowdownSpeed)
		character_body.velocity.x = lerp(character_body.velocity.x, direction.x * speed, delta * 3.0)
		character_body.velocity.z = lerp(character_body.velocity.z, direction.z * speed, delta * 3.0)
		
	#float(is_on_floor()) results in 1 or 0
	# velocity.length() determines the bob speed, delta regulates, is_on_floor initiates
	t_bob += delta * character_body.velocity.length() * float(on_floor)
	camera.transform.origin = _headbob(t_bob) # Origin is same as position
	#print(camera.transform.origin)
	
	# FOV
	var velocity_clamped = clamp(character_body.velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	
	character_body.move_and_slide() # Allows for velocity to take affect once applied


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO # Bob offset
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
