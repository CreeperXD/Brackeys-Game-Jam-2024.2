class_name Cyberattack extends CyberObject

signal attack_queued

@export var attack_strength: float = 25
@export var attack_range: float = 25
@export var initial_attack_cooldown: float = 1
@export var movement_speed: float = 5

var current_attack_cooldown: float = 0:
	set(value):
		current_attack_cooldown = clampf(value, 0, initial_attack_cooldown)
var target

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	#Assign the nearest server component as the target if it is not assigned
	if target == null:
		print(get_tree().get_nodes_in_group("server_component"))
		var potential_targets: Array[Node] = get_tree().get_nodes_in_group("server_component")#Array[ServerComponent]
		#var scanned_nodes: Array[Node] = get_tree().get_nodes_in_group("server_component")
		#for node: Node in scanned_nodes:
			#if node is ServerComponent:
				#otential_targets.append(node)
		var distance_to_potential_targets: Array[float]
		for potential_target in potential_targets:
			distance_to_potential_targets.append(position.distance_to(potential_target.position))
		target = potential_targets[distance_to_potential_targets.find(distance_to_potential_targets.min())]
	
	if position.distance_to(target.position) <= attack_range and current_attack_cooldown == 0:
		attack_queued.emit()
		current_attack_cooldown = initial_attack_cooldown
	
	current_attack_cooldown -= delta

func _physics_process(delta: float) -> void:
	if target != null and current_attack_cooldown == 0:
		position.move_toward(target.position, movement_speed)

func _on_destroyed() -> void:
	print("Game over!")
