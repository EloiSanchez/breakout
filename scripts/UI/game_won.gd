extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("end_game")

func back_to_main_menu():
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
