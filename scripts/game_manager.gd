extends Node

signal wave_finished

@export	var brute_force_scene: PackedScene
@export var storm_scene: PackedScene

var waves: Dictionary = {
	1: {
		1: {
			"cyberattack": BruteForce,
			"amount": 15,
			"spawn_start_time": 0.0,
			"spawn_duration": 5.0
		},
		2: {
			"cyberattack": BruteForce,
			"amount": 10,
			"spawn_start_time": 5.0,
			"spawn_duration": 0.0
		}
	},
	2: {
		1: {
			"cyberattack": BruteForce,
			"amount": 50,
			"spawn_start_time": 0,
			"spawn_duration": 10.0
		},
		2: {
			"cyberattack": BruteForce,
			"amount": 50,
			"spawn_start_time": 10.0,
			"spawn_duration": 5.0
		},
		3: {
			"cyberattack": STORM,
			"amount": 1,
			"spawn_start_time": 15.0,
			"spawn_duration": 0.0
		}
	}
}
var current_wave: int = 0
var is_final_wave: bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_next_wave_timer_timeout() -> void:
	current_wave += 1
	if current_wave == waves.size():
		is_final_wave = true
	await spawn_wave(current_wave)
	print("hello")

func spawn_wave(wave: int) -> void:
	var wave_content: Dictionary = waves[wave]
	for subwave in wave_content:
		spawn_subwave(wave_content[subwave])

func spawn_subwave(subwave: Dictionary) -> void:
	var cyberattack_scene: PackedScene
	match subwave.cyberattack:
		BruteForce:
			cyberattack_scene = brute_force_scene
		STORM:
			cyberattack_scene = storm_scene
	
	await get_tree().create_timer(subwave.spawn_start_time, false).timeout
	for i in range(subwave.amount):
		#Spawn on a random point in the path
		$SpawnPath/SpawnLocation.progress_ratio = randf()
		spawn_cyberattack(cyberattack_scene, $SpawnPath/SpawnLocation.position)
		if subwave.amount - 1 == 0:
			return
		await get_tree().create_timer(subwave.spawn_duration / (subwave.amount - 1), false).timeout

func spawn_cyberattack(cyberattack_scene: PackedScene, position: Vector3) -> void:
	var cyberattack: Cyberattack = cyberattack_scene.instantiate()
	cyberattack.position = position
	$Cyberattacks.add_child(cyberattack)
