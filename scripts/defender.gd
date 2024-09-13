extends CharacterBody3D

enum Turrets {NOTHING, LASER_BEAM, EXPLOSIVE}

@export_range(0.25, 1) var mouse_sensitivity: float = 1
@export var movement_speed: float = 5
@export var ray_length: float = 1000
@export var laser_beam_turret_scene: PackedScene
@export var explosive_turret_scene: PackedScene

var mouse_rotation: Vector3
var rotation_input: float
var tilt_input: float
var raycast_result: Dictionary
var selected_turret: Turrets = 0

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_input = -event.relative.x
		tilt_input = -event.relative.y
	
	if Input.is_action_just_pressed("0"):
		selected_turret = Turrets.NOTHING
	if Input.is_action_just_pressed("1"):
		selected_turret = Turrets.LASER_BEAM
	if Input.is_action_just_pressed("2"):
		selected_turret = Turrets.EXPLOSIVE
	
	if Input.is_action_just_pressed("left_mouse_button_click") and raycast_result:
		var selected_turret_instance: Turret
		match selected_turret:
			Turrets.NOTHING:
				pass
			Turrets.LASER_BEAM:
				selected_turret_instance = laser_beam_turret_scene.instantiate()
			Turrets.EXPLOSIVE:
				selected_turret_instance = explosive_turret_scene.instantiate()
		if selected_turret_instance:
			selected_turret_instance.position = raycast_result.position + Vector3.UP * 0.5
			get_parent().add_child(selected_turret_instance)

func _physics_process(delta: float) -> void:
	rotate_player(delta)
	
	# Get the input direction and handle the movement/deceleration.
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	if direction:
		velocity = direction * movement_speed
	else:
		velocity = Vector3.ZERO
	
	raycast_result = raycast()
	
	move_and_slide()

func rotate_player(delta: float) -> void:
	mouse_rotation.x += tilt_input * mouse_sensitivity * delta
	mouse_rotation.x = clamp(mouse_rotation.x, -PI / 2, PI / 2)
	mouse_rotation.y += rotation_input * mouse_sensitivity * delta
	
	transform.basis = Basis.from_euler(mouse_rotation)
	
	rotation_input = 0
	tilt_input = 0

func raycast() -> Dictionary:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = $Camera3D.project_ray_origin(mouse_position)
	var ray_end: Vector3 = ray_origin + $Camera3D.project_ray_normal(mouse_position) * ray_length
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 1)
	#query.collide_with_areas = true
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	return space_state.intersect_ray(query)
