class_name Board
extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var trajectory_source: Marker2D = $TrajectorySource

var textures: Array[CompressedTexture2D] = [
	load("res://assets/art/board/board-1.png"), 
	load("res://assets/art/board/board-2.png")
]

const SPEED = 300.0
var board_size_level: int = 1
var width: int
var screen_width: int
@onready var size_level: int:
	set(value):
		size_level = clamp(value, 0, 1)
		sprite.texture = textures[size_level]
		collision.shape.size.x = sprite.texture.get_width()
		width = sprite.texture.get_width()

func _ready() -> void:
	size_level = 0
	screen_width = get_viewport_rect().size.x

func _physics_process(delta: float) -> void:
	var direction: int = handle_input()
	move(delta, direction)

func handle_input() -> int:
	if Input.is_action_pressed("move_left"):
		return -1
	elif Input.is_action_pressed("move_right"):
		return 1
	else:
		return 0

func move(delta: float, direction: int):
	position.x += direction * SPEED * delta
	position.x = fit_to_screen(position.x)

func fit_to_screen(x: int) -> int:
	x = clamp(x, 96 + width / 2, screen_width - width / 2)
	return x

func _on_body_entered(ball: Ball) -> void:
	ball._on_board_collision(trajectory_source.global_position)

func increase_size():
	size_level += 1

func decrease_size():
	size_level -= 1
