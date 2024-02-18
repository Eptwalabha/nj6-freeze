class_name TinyInmate

extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var global_target : Vector2 = global_position
var moving : bool = false

const SPEED : float = 3.0

func _process(delta: float) -> void:
	if moving:
		global_position += (global_target - global_position).normalized() * delta * SPEED

func move_to(target: Vector2, wait: float = 0.0) -> void:
	if wait > 0.0:
		await get_tree().create_timer(wait).timeout
	global_target = target
	moving = true
	sprite.flip_v = global_target.x < global_position.x
