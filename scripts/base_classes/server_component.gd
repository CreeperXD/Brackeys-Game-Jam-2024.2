class_name ServerComponent extends CyberObject

func _process(delta: float) -> void:
	pass

func _on_destroyed() -> void:
	print("Server component destroyed!")
