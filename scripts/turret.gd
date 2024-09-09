extends ServerComponent

signal attack_queued

@export var attack_strength: float = 25
@export var attack_range: float = 25
@export var initial_attack_cooldown: float = 1

var current_attack_cooldown: float = 0:
	set(value):
		current_attack_cooldown = clampf(value, 0, initial_attack_cooldown)
var target: Cyberattack

func _process(delta: float) -> void:
	if target == null:
		target = search_closest_target("cyberattack")
	else:
		if position.distance_to(target.position) <= attack_range and current_attack_cooldown == 0:
			attack_queued.emit()
			current_attack_cooldown = initial_attack_cooldown
	
	current_attack_cooldown -= delta

func _on_destroyed() -> void:
	print("Turret destroyed!")
	queue_free()

func _on_attack_queued() -> void:
	target.current_integrity -= attack_strength
