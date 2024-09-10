class_name LaserBeam extends Projectile

func _ready() -> void:
	body_entered.connect(_on_body_entered.bind())

func _process(delta: float) -> void:
	position += rotation.rotated(Vector3.UP, -PI / 2).normalized() * speed * delta
	lifetime -= delta
	if lifetime < 0:
		queue_free()

func _on_body_entered(body: CyberObject) -> void:
	#print(str(self) + ": I hit " + str(body) + " and it still has an intergrity of " + str(body.current_integrity))
	if body.collision_layer == target.collision_layer:
		body.current_integrity -= damage
		queue_free()

func initialise(initial_position: Vector3, projectile_target: CyberObject, projectile_damage: float, projectile_speed: float, projectile_lifetime: float) -> void:
	#Rotation is not here since the local rotation inherits from rotation of parent node, which in this case is the turret
	position = initial_position
	target = projectile_target
	damage = projectile_damage
	speed = projectile_speed
	lifetime = projectile_lifetime
