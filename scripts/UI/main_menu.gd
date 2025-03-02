extends Control



func _on_start_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_select_level_button_button_up() -> void:
	pass # Replace with function body.


func _on_quit_button_button_up() -> void:
	get_tree().quit()
