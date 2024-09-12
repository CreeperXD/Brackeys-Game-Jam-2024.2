class_name CyberObject extends CharacterBody3D

signal integrity_changed(new_integrity: float)
signal destroyed

@export var max_integrity: float = 100
@export var current_integrity: float = 100:
	set(value):
		current_integrity = clampf(value, 0, max_integrity)
		integrity_changed.emit(current_integrity)

func _ready() -> void:
	integrity_changed.connect(_on_integrity_changed.bind())

func _process(delta: float) -> void:
	pass

func _on_integrity_changed(new_integrity: float) -> void:
	#print(str(self) + str(new_integrity))
	if new_integrity == 0:
		destroyed.emit()

func search_closest_target(group: StringName) -> CyberObject:
	var potential_targets: Array[Node] = get_tree().get_nodes_in_group(group)
	var distance_to_potential_targets: Array[float]
	for potential_target in potential_targets:
		distance_to_potential_targets.append(position.distance_to(potential_target.position))
	if potential_targets.is_empty():
		return null
	return potential_targets[distance_to_potential_targets.find(distance_to_potential_targets.min())]

func rotate_towards_target(target: CyberObject) -> void:
	var target_vector: Vector3 = global_position.direction_to(target.position)
	var target_basis: Basis = Basis.looking_at(target_vector.rotated(Vector3.UP, PI / 2))
	basis = basis.slerp(target_basis, 0.5)
