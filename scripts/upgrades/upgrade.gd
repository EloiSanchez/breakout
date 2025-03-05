@tool
class_name Upgrade
extends Area2D

signal picked_up(upgrade: BaseUpgrade)

@export var upgrade_resource: BaseUpgrade:
	set(val):
		upgrade_resource = val
		needs_update = true
@export var needs_update: bool = false
@export var falling_velocity: int = 150

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = upgrade_resource.texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if needs_update and upgrade_resource and upgrade_resource.texture:
			sprite_2d.texture = upgrade_resource.texture
		needs_update = false
	else:
		position.y += falling_velocity * delta

func _on_area_entered(area: Area2D) -> void:
	if area is Board:
		SignalBus.picked_up_upgrade.emit(upgrade_resource, self)
