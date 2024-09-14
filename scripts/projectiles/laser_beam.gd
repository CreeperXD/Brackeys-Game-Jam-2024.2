class_name LaserBeam extends Projectile

func _ready() -> void:
	body_entered.connect(_on_body_entered.bind())

func _process(delta: float) -> void:
	position += direction * speed * delta
	lifetime -= delta
	if lifetime < 0:
		queue_free()

func _on_body_entered(body: CyberObject) -> void:
	if body.collision_layer == target_collision_layer:
		body.current_integrity -= damage
		queue_free()

func initialise(initial_position: Vector3, target: CyberObject, projectile_rotation: Vector3, projectile_damage: float, projectile_speed: float, projectile_lifetime: float) -> void:
	position = initial_position
	target_collision_layer = target.collision_layer
	direction = position.direction_to(target.position)
	rotation = projectile_rotation
	damage = projectile_damage
	speed = projectile_speed
	lifetime = projectile_lifetime
