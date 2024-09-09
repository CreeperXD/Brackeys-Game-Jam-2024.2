extends ServerComponent

func _process(delta: float) -> void:
	pass

func _on_destroyed() -> void:
	print("Battery destroyed!")
	queue_free()
