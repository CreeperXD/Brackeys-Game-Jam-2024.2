class_name ServerComponent extends CyberObject

#This will override the _ready() in CyberObject
#func _ready() -> void:
	#pass

func _process(delta: float) -> void:
	pass

func _on_destroyed() -> void:
	print("Server component destroyed!")
