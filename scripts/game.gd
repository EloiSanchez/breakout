extends Node2D

signal life_changed

@onready var ball: PackedScene = load("res://scenes/objects/ball.tscn")
@onready var health_container: PackedScene = load("res://scenes/UI/objects/health_container.tscn")
@onready var ball_spawn: Marker2D = $BallSpawn
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var level_label: Label = $UI/MarginContainer/VBoxContainer/LevelLabel
@onready var ui_message: Label = $UI/Control/UIMessage
@onready var board: Board = $Board
@onready var health_section: HFlowContainer = $UI/MarginContainer/VBoxContainer/HealthSection/HBoxContainer

@export var lifes: int = 3
@export var level_number: int = 0

var level: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.picked_up_upgrade.connect(_perform_upgrade)
	animation.play("start_game")
	for life in range(lifes):
		var health_cont_inst = health_container.instantiate()
		health_cont_inst.name += str(life)
		health_section.add_child(health_cont_inst)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_ball(pos: Vector2, start_moving: bool = false, start_timer: bool = false):
	var ball_instance: Ball = ball.instantiate()
	ball_instance.position = pos
	ball_instance.enable_movement = start_moving
	ball_instance.start_on_timer = start_timer
	call_deferred("add_child", ball_instance)

func load_level() -> void:
	get_tree().call_group("balls", "queue_free")
	if level:
		level.queue_free()
	var level_loader: PackedScene = load("res://scenes/levels/level_%s.tscn" % level_number)
	level = level_loader.instantiate()
	spawn_ball(ball_spawn.global_position)
	add_child(level)
	for block: Block in get_tree().get_nodes_in_group("blocks"):
		block.destroyed.connect(_check_level_finished)

func start_moving_balls():
	get_tree().call_group("balls", "start_moving")

func _check_level_finished():
	if not get_tree().get_nodes_in_group("blocks"):
		if level_number >= 6:
			game_won()
		else:
			level_won()

func level_won():
	level_number += 1
	board.decrease_size()
	animation.play("start_game")

func game_won():
	get_tree().change_scene_to_file("res://scenes/UI/game_won.tscn")
	queue_free()

func update_text_labels():
	var text = "Level %s" % level_number
	level_label.text = text
	ui_message.text = text

# On ball lost
func _on_area_2d_body_entered(ball: Ball) -> void:
	ball._remove_ball()
	var balls = get_tree().get_nodes_in_group("balls")
	if not balls:
		lose_life()

func lose_life():
	lifes -= 1
	life_changed.emit()
	health_section.get_node("HealthContainer%s" % lifes).queue_free()
	board.decrease_size()
	if lifes == 0:
		animation.play("game_over")
	else:
		spawn_ball(ball_spawn.global_position, false, true)
		
func increase_life():
	var health_cont_inst = health_container.instantiate()
	health_cont_inst.name += str(lifes)
	health_section.add_child(health_cont_inst)
	lifes += 1
	life_changed.emit()

func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("ui_cancel"):
			to_main_menu()

func to_main_menu():
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
	#queue_free()

func _perform_upgrade(upgrade: BaseUpgrade, upgrade_node: Upgrade):
	print("Upgrade picked. Calling perform upgrade from game")
	upgrade.perform_effect(self, upgrade_node)
