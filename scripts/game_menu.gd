extends CanvasLayer

func _ready() -> void:
	hide_pause_menu()
	hide_game_over_menu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		show_pause_menu()

func _on_resume_button_pressed() -> void:
	hide_pause_menu()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func show_turret_spawning_info() -> void:
	$TurretSpawningInfo.show()

func hide_turret_spawning_info() -> void:
	$TurretSpawningInfo.hide()

func show_pause_menu() -> void:
	$PauseMenu.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func hide_pause_menu() -> void:
	$PauseMenu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func update_wave_label(seconds: float, wave: int) -> void:
	if seconds > 0:
		$WaveLabel.text = "Next wave in " + str(ceil(seconds)) + " seconds, ability to place turrets will be disabled"
	else:
		$WaveLabel.text = "Wave " + str(wave)

func update_power_label(power: int) -> void:
	$TurretSpawningInfo/Power/Label.text = str(power)

func show_game_over_menu(type: String) -> void:
	$GameOverMenu.show()
	if type == "won":
		$GameOverMenu/ColorRect.color = Color(50, 200, 50, 255)
		$GameOverMenu/Label.text = "You successfully repelled S.T.O.R.M. and its forces"
	else:
		$GameOverMenu/ColorRect.color = Color.RED
		$GameOverMenu/Label.text = "S.T.O.R.M.'s forces destroyed the CPU"
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func hide_game_over_menu() -> void:
	$GameOverMenu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
