class_name Projectile extends Area3D

var caster: CyberObject
var damage: float = 25

func _ready() -> void:
	body_entered.connect(_on_body_entered.bind())

func _on_body_entered(body: CyberObject):
	body.current_integrity -= damage
