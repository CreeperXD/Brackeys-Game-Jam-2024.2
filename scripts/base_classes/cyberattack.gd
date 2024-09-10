class_name Cyberattack extends CyberObject

signal attack_queued

@export var attack_strength: float = 25
@export var attack_range: float = 25
@export var initial_attack_cooldown: float = 1
@export var movement_speed: float = 5

var current_attack_cooldown: float = 0:
	set(value):
		current_attack_cooldown = clampf(value, 0, initial_attack_cooldown)
var target: ServerComponent

func _process(delta: float) -> void:
	if target == null:
		target = search_closest_target("server_component")
	else:
		if current_attack_cooldown == 0:
			rotate_towards_target(target)
			if position.distance_to(target.position) <= attack_range:
				attack_queued.emit()
				current_attack_cooldown = initial_attack_cooldown
	
	current_attack_cooldown -= delta

func _physics_process(delta: float) -> void:
	if target != null and current_attack_cooldown == 0:
		position = position.move_toward(target.position, movement_speed * delta)

func _on_destroyed() -> void:
	print("Cyberattack destroyed!")
