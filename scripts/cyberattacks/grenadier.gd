class_name Grenadier extends Cyberattack

@export var explosive_scene: PackedScene

func _on_attack_queued() -> void:
	var explosive: Explosive = explosive_scene.instantiate()
	explosive.initialise($FirePoint.global_position, target, rotation, attack_strength, 50, 2)
	get_parent().add_child(explosive)

func _on_destroyed() -> void:
	print("Brute force destroyed!")
	queue_free()
