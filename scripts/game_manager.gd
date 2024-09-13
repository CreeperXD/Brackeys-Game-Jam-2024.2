extends Node

@export	var brute_force_scene: PackedScene
@export var storm_scene: PackedScene
@export var waves: Dictionary = {
	1: {
		1: {
			"brute_force": {
				"amount": 5,
				"spawn_start_time": 0,
				"spawn_duration": 3
			}
		},
		2: {
			"brute_force": {
				"amount": 5,
				"spawn_start_time": 3,
				"spawn_duration": 2
			}
		}
	},
	2: {
		1: {
			"brute_force": {
				"amount": 5,
				"spawn_start_time": 0,
				"spawn_duration": 3
			}
		}
	}
}

var current_wave: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	#Change to spawn enemies based on the waves dictionary
	var enemy: Cyberattack = brute_force_scene.instantiate()
	enemy.position = Vector3(randf_range(-100, 100), 0.5, randf_range(-100, 100))
	get_parent().add_child(enemy)
	
	
