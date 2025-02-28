class_name Board
extends Area2D

signal ball_collision(source_position: Vector2)

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var trajectory_source: Marker2D = $TrajectorySource


const SPEED = 300.0
var width: int
var screen_width: int

func _ready() -> void:
	width = sprite.texture.get_width()
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
	x = min(x, screen_width - width / 2)
	x = max(x, width / 2)
	return x

func _on_body_entered(body: Ball) -> void:
	ball_collision.emit(trajectory_source.global_position)
