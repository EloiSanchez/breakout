extends Control

@onready var main_buttons: VBoxContainer = $MarginContainer/VBoxContainer/CenterContainer/MainButtons
@onready var level_selection: GridContainer = $MarginContainer/VBoxContainer/CenterContainer/LevelMenu/LevelSelection
@onready var level_menu: VBoxContainer = $MarginContainer/VBoxContainer/CenterContainer/LevelMenu

var game = preload("res://scenes/game.tscn")

func _ready():
	for button in level_selection.get_children():
		button.pressed.connect(_to_level.bind(button.text))

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game)

func _on_select_level_button_pressed() -> void:
	main_buttons.hide()
	level_menu.show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _to_level(level: String):
	var game_instance = game.instantiate()
	game_instance.level_number = int(level)
	get_tree().root.add_child(game_instance)
	queue_free()

func _on_back_button_pressed() -> void:
	main_buttons.show()
	level_menu.hide()
