extends Node

@export var scenes: Array[PackedScene]

var current_scene_index: int = 0

func change_scene(index: int) -> void:
	call_deferred("deferred_change_scene", index)

#Only to be called in change_scene() via call_deferred()
func deferred_change_scene(index: int) -> void:
	var root = get_tree().root
	#Delete current loaded scene before loading a new scene
	#Autoloaded nodes are always first, meaning the last child of root is always the loaded scene
	root.get_child(root.get_child_count() - 1).free()
	if index >= scenes.size():
		index = 0
		push_warning("Given index larger than " + str(scenes.size() - 1) + ", defaulting to 0")
	var new_scene = scenes[index].instantiate()
	root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene_index = index

func change_to_next_scene() -> void:
	change_scene(current_scene_index + 1)
