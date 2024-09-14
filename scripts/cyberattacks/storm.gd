class_name STORM extends Cyberattack

func _on_attack_queued() -> void:
	target.current_integrity -= attack_strength

func _on_destroyed() -> void:
	print("S.T.O.R.M. destroyed!")
	queue_free()
