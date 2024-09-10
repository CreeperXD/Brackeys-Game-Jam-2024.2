extends Turret

@export var laser_beam_scene: PackedScene

func _ready() -> void:
	integrity_changed.connect(_on_integrity_changed.bind())
	attack_queued.connect(_on_attack_queued.bind())

func _on_attack_queued() -> void:
	var laser_beam: LaserBeam = laser_beam_scene.instantiate()
	#print(target)
	#print(laser_beam.position)
	laser_beam.initialise($FirePoint.position, target, attack_strength, 100, 1)
	add_child(laser_beam)

func _on_destroyed() -> void:
	print("Laser beam turret destroyed!")
	queue_free()
