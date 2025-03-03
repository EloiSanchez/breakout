@tool
class_name Block
extends StaticBody2D

signal destroyed

@export var upgrade_resource: BaseUpgrade:
	set(value):
		upgrade_resource = value
		needs_update = true
var upgrade: PackedScene = load("res://scenes/upgrades/upgrade.tscn")
@export var needs_update = false
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
	modulate = Color(1, 1, 1, 1)
	sprite.texture = color_sprite
	health = max_health

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if needs_update:
			if upgrade_resource:
				modulate.b = 0
			else:
				modulate.b = 1
			needs_update = false


func _on_ball_collision():
	take_damage()
	
func take_damage() -> void:
	health -= 1
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
	
	if upgrade_resource:
		var upgrade : Upgrade = upgrade.instantiate()
		upgrade.upgrade_resource = upgrade_resource
		upgrade.global_position = global_position
		get_tree().root.add_child(upgrade)
	
	destroyed.emit()
	
	

func _on_destroyed_particles_finished() -> void:
	queue_free()
