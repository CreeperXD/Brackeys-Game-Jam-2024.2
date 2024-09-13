class_name BruteForce extends Cyberattack

func _on_attack_queued() -> void:
	target.current_integrity -= attack_strength

func _on_destroyed() -> void:
	print("Brute force destroyed!")
	queue_free()
