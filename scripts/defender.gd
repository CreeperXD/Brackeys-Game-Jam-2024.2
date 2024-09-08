extends CharacterBody3D

@export_range(0.25, 1) var mouse_sensitivity: float = 1
@export var movement_speed: float = 5

var mouse_rotation: Vector3
var rotation_input: float
var tilt_input: float

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	var mouse_moved: bool = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if mouse_moved:
		rotation_input = -event.relative.x
		tilt_input = -event.relative.y

func rotate_player(delta):
	mouse_rotation.x += tilt_input * mouse_sensitivity * delta
	mouse_rotation.x = clamp(mouse_rotation.x, -PI / 2, PI / 2)
	mouse_rotation.y += rotation_input * mouse_sensitivity * delta
	
	transform.basis = Basis.from_euler(mouse_rotation)
	
	rotation_input = 0
	tilt_input = 0

func _physics_process(delta: float) -> void:
	rotate_player(delta)
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity = direction * movement_speed
	else:
		velocity = Vector3.ZERO

	move_and_slide()
