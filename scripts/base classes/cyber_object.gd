class_name CyberObject extends CharacterBody3D

signal integrity_changed(new_integrity: float)
signal destroyed

@export var max_integrity: float = 100
@export var current_integrity: float = 100:
	set(value):
		current_integrity = clampf(value, 0, max_integrity)
		integrity_changed.emit(current_integrity)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_integrity_changed(new_integrity: float) -> void:
	if new_integrity == 0:
		destroyed.emit()
