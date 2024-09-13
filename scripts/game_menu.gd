extends CanvasLayer

func _ready() -> void:
	hide_pause_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		show_pause_menu()

func _on_resume_button_pressed() -> void:
	hide_pause_menu()

func _on_main_menu_button_pressed() -> void:
	pass # Replace with function body.

func show_pause_menu() -> void:
	$PauseMenu.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func hide_pause_menu() -> void:
	$PauseMenu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
