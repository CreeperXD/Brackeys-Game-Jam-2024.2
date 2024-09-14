class_name ExplosiveTurret extends Turret

@export var explosive_scene: PackedScene

func _ready() -> void:
	integrity_changed.connect(_on_integrity_changed.bind())
	attack_queued.connect(_on_attack_queued.bind())

func _on_attack_queued() -> void:
	var explosive: Explosive = explosive_scene.instantiate()
	explosive.initialise($FirePoint.global_position, target, rotation, attack_strength, 25, 5)
	get_parent().add_child(explosive)

func _on_destroyed() -> void:
	print("Laser beam turret destroyed!")
	queue_free()
