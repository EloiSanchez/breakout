extends Node2D

signal life_lost

@onready var ball: PackedScene = load("res://scenes/objects/ball.tscn")
@onready var ball_spawn: Marker2D = $BallSpawn

@export var lifes: int = 3
@export var level_number: int = 1

var level: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(level_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_ball():
	print("Instantiating ball")
	var ball_instance: Ball = ball.instantiate()
	ball_instance.position = ball_spawn.global_position
	add_child(ball_instance)

func load_level(level_number: int) -> void:
	if level:
		level.queue_free()
	var level_loader: PackedScene = load("res://scenes/levels/level_%s.tscn" % level_number)
	level = level_loader.instantiate()
	add_child(level)
	
# On ball lost
func _on_area_2d_body_entered(ball: Ball) -> void:
	print("Ball lost")
	ball._remove_ball()
	var balls = get_tree().get_nodes_in_group("balls")
	print(balls)
	if not balls:
		print("No balls left")
		lose_life()
		
func lose_life():
	print("Life lost")
	lifes -= 1
	life_lost.emit()
	if lifes == 0:
		end_game()
	else:
		spawn_ball()
		
func end_game():
	pass
