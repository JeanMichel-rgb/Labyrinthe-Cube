extends CharacterBody3D


var SPEED = 5.0
var JUMP_VELOCITY = 4.5
var mouse_sensibility : float = .006
@onready var camera : Camera3D = get_node("Camera3D")
var can_jump = false

func _physics_process(delta: float) -> void:
	if can_jump:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("q", "d", "z", "s")
	var direction := (global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity = direction * SPEED
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left click"):
		Input.set_mouse_mode(2)
	elif Input.is_action_just_pressed("wheel click") or Input.is_action_just_pressed("right click") or Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(0)
	
	if Input.get_mouse_mode() == 2 and event is InputEventMouseMotion:
		event.relative *= -mouse_sensibility
		rotation.y += event.relative.x 
		rotation.x += event.relative.y
		rotation.x = clamp(rotation.x,-PI/2, PI/2)
