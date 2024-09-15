extends CanvasLayer

func _on_play_button_pressed() -> void:
	SceneManager.change_scene(1)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_button_hover() -> void:
	$ButtonHover.play()

func _on_button_click() -> void:
	$ButtonClick.play()
