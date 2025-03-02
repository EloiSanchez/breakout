extends Label

@export var game: Node

var base_text = "Lifes: %s"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_life_lost() -> void:
	update_text()

func update_text():
	text = base_text % game.lifes
	
