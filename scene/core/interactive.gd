class_name Interactive
extends Area2D

signal player_entered
signal player_exited
signal player_interacted

@onready var collision : CollisionShape2D = $CollisionShape2D
@export var item_name : String = ""

var in_range : bool = false
var enabled : bool = true : set = _set_enabled

func _set_enabled(is_enabled: bool) -> void:
	enabled = is_enabled
	collision.set_deferred("disabled", not enabled)

func _input(event):
	if not enabled:
		return
	if in_range and event.is_action_pressed("action-confirm"):
		player_interacted.emit()
		_set_enabled(false)

func _on_body_entered(body: Node2D) -> void:
	if not in_range and body is Player:
		in_range = true
		player_entered.emit()

func _on_body_exited(body: Node2D) -> void:
	if in_range and body is Player:
		in_range = false
		player_exited.emit()
