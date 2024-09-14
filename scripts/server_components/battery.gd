class_name Battery extends ServerComponent

@export var power_per_wave: int = 5

func _process(delta: float) -> void:
	pass

func _on_destroyed() -> void:
	print("Battery destroyed!")
	queue_free()
