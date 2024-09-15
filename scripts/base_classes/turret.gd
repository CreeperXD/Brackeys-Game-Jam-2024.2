class_name Turret extends ServerComponent

signal attack_queued

@export var cost: int = 4
@export var attack_strength: float = 25
@export var attack_range: float = 25
@export var initial_attack_cooldown: float = 1
@export var projectile_speed: float = 50
@export var projectile_lifetime: float = 5

var current_attack_cooldown: float = 0:
	set(value):
		current_attack_cooldown = clampf(value, 0, initial_attack_cooldown)
var target: Cyberattack

func _process(delta: float) -> void:
	if is_instance_valid(target) and position.distance_to(target.position) <= attack_range:
		rotate_towards_target(target)
		if current_attack_cooldown == 0:
			attack_queued.emit()
			current_attack_cooldown = initial_attack_cooldown
		current_attack_cooldown -= delta
	else:
		target = search_closest_target("cyberattack")
		current_attack_cooldown = initial_attack_cooldown

func _on_destroyed() -> void:
	print("Turret destroyed!")
	queue_free()
