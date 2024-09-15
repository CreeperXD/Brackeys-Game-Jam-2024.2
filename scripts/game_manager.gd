extends Node

@export	var brute_force_scene: PackedScene
@export var grenadier_scene: PackedScene
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
			"amount": 25,
			"spawn_start_time": 0.0,
			"spawn_duration": 10.0
		},
		2: {
			"cyberattack": BruteForce,
			"amount": 25,
			"spawn_start_time": 10.0,
			"spawn_duration": 5.0
		}
	},
	3: {
		1: {
			"cyberattack": Grenadier,
			"amount": 25,
			"spawn_start_time": 0.0,
			"spawn_duration": 10.0
		},
		2: {
			"cyberattack": BruteForce,
			"amount": 25,
			"spawn_start_time": 5.0,
			"spawn_duration": 10.0
		}
	},
	4: {
		1: {
			"cyberattack": Grenadier,
			"amount": 10,
			"spawn_start_time": 0.0,
			"spawn_duration": 10.0
		},
		2: {
			"cyberattack": Grenadier,
			"amount": 10,
			"spawn_start_time": 2.0,
			"spawn_duration": 10.0
		},
		3: {
			"cyberattack": Grenadier,
			"amount": 10,
			"spawn_start_time": 4.0,
			"spawn_duration": 10.0
		},
		4: {
			"cyberattack": Grenadier,
			"amount": 10,
			"spawn_start_time": 6.0,
			"spawn_duration": 10.0
		},
		5: {
			"cyberattack": Grenadier,
			"amount": 10,
			"spawn_start_time": 8.0,
			"spawn_duration": 10.0
		}
	}
}
var current_wave: int = 0:
	set(value):
		current_wave = value
		if current_wave == waves.size():
			is_final_wave = true
var is_final_wave: bool = false
var cyberattacks_to_spawn: int = 0:
	set(value):
		cyberattacks_to_spawn = value
		if not finished_spawning and cyberattacks_to_spawn == 0:
			finished_spawning = true
var finished_spawning: bool = true
var remaining_cyberattacks: int = 0:
	set(value):
		remaining_cyberattacks = value
		if finished_spawning and remaining_cyberattacks == 0:
			wave_finished = true
var wave_finished: bool = true:
	set(value):
		if value != wave_finished:
			wave_finished = value
			if wave_finished:
				prepare_next_wave()

func _ready() -> void:
	prepare_next_wave()

func _process(delta: float) -> void:
	$GameMenu.update_wave_label($NextWaveTimer.time_left, current_wave)

func _on_next_wave_timer_timeout() -> void:
	$Defender.can_place_turrets = false
	$GameMenu.hide_turret_spawning_info()
	finished_spawning = false
	wave_finished = false
	current_wave += 1
	spawn_wave(current_wave)

func _on_cyberattack_destroyed() -> void:
	await get_tree().create_timer(0.01, true).timeout
	remaining_cyberattacks = $Cyberattacks.get_child_count()

func _on_defender_power_changed(new_power: int) -> void:
	$GameMenu.update_power_label(new_power)

func _on_cpu_destroyed() -> void:
	$GameMenu.show_game_over_menu("lost")

func prepare_next_wave() -> void:
	if is_final_wave:
		$GameMenu.show_game_over_menu("won")
	else:
		$Defender.can_place_turrets = true
		$GameMenu.show_turret_spawning_info()
		for battery: Battery in get_tree().get_nodes_in_group("battery"):
			$Defender.power += battery.power_per_wave
		$NextWaveTimer.start()

func spawn_wave(wave: int) -> void:
	var wave_content: Dictionary = waves[wave]
	for subwave in wave_content:
		spawn_subwave(wave_content[subwave])
		cyberattacks_to_spawn += wave_content[subwave].amount

func spawn_subwave(subwave: Dictionary) -> void:
	var cyberattack_scene: PackedScene
	match subwave.cyberattack:
		BruteForce:
			cyberattack_scene = brute_force_scene
		STORM:
			cyberattack_scene = storm_scene
		Grenadier:
			cyberattack_scene = grenadier_scene
	
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
	cyberattack.destroyed.connect(_on_cyberattack_destroyed.bind())
	$Cyberattacks.add_child(cyberattack)
	cyberattacks_to_spawn -= 1
