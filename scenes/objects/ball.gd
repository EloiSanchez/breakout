class_name Ball
extends RigidBody2D

@export var velocity_increase: float = 1.05
@export var max_velocity: int = 400
@export var velocity: Vector2 = Vector2(0, -180)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player: Board = get_tree().get_first_node_in_group("player")
	player.ball_collision.connect(_on_board_collision)
	velocity.x = randi_range(-20, 20)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	# Move and detect collisions
	var collisions = move_and_collide(velocity * delta)

	# Handle collisions if happened
	if collisions:
		handle_collisions(collisions)

func _on_board_collision(trajectory_source: Vector2):
	velocity = trajectory_source.direction_to(position) * velocity.length()

func handle_collisions(collisions: KinematicCollision2D) -> void:
		# Change ball direction
		velocity = velocity.bounce(collisions.get_normal())
		
		# If collision with block, trigger block to be hit and increase ball speed
		var collider = collisions.get_collider()
		if is_instance_of(collider, Block):
			collider._on_ball_collision()
			increase_speed()


func increase_speed() -> void:
	velocity = velocity.normalized() * min(velocity.length() * velocity_increase, max_velocity)
