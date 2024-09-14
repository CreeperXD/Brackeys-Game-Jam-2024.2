class_name RepairOrbTurret extends Turret

@export var repair_orb_scene: PackedScene

var target_server_component: ServerComponent

func _ready() -> void:
	integrity_changed.connect(_on_integrity_changed.bind())
	attack_queued.connect(_on_attack_queued.bind())

func _process(delta: float) -> void:
	if (is_instance_valid(target_server_component) and
	position.distance_to(target_server_component.position) <= attack_range and
	target_server_component.current_integrity < target_server_component.max_integrity):
		rotate_towards_target(target_server_component)
		if current_attack_cooldown == 0:
			attack_queued.emit()
			current_attack_cooldown = initial_attack_cooldown
		current_attack_cooldown -= delta
	else:
		target_server_component = search_weakest_server_component()

func _on_attack_queued() -> void:
	var repair_orb: RepairOrb = repair_orb_scene.instantiate()
	repair_orb.initialise($FirePoint.global_position, target_server_component, attack_strength, 25, 5)
	get_parent().add_child(repair_orb)

func _on_destroyed() -> void:
	print("Repair orb turret destroyed!")
	queue_free()

func search_weakest_server_component() -> ServerComponent:
	var server_components: Array[Node] = get_tree().get_nodes_in_group("server_component")
	var server_components_integrity_ratio: Array[float]
	for server_component: ServerComponent in server_components:
		server_components_integrity_ratio.append(server_component.current_integrity / server_component.max_integrity)
	var candidate_server_component: ServerComponent = server_components[server_components_integrity_ratio.find(server_components_integrity_ratio.min())]
	if candidate_server_component == self or server_components_integrity_ratio.min() == 1:
		return null
	return candidate_server_component
