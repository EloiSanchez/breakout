class_name Block
extends StaticBody2D

signal destroyed

@export var color_sprite: Texture2D
@export_range(1, 4, 1) var max_health: int
var health: int

@onready var sprite = $Sprite2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var hit_particles = $HitParticles
@onready var destroyed_particles = $DestroyedParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = color_sprite
	health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ball_collision():
	take_damage()
	
func take_damage() -> void:
	health -= 1
	print(health)
	if health == 0:
		disappear()
	
	animated_sprite.play(str(max_health - health))
		
	hit_particles.emitting = true

func disappear():
	destroyed_particles.emitting = true
	
	remove_from_group("blocks")
	
	sprite.queue_free()
	hit_particles.queue_free()
	animated_sprite.queue_free()
	collision_shape.queue_free()
	destroyed.emit()
	
	

func _on_destroyed_particles_finished() -> void:
	queue_free()
