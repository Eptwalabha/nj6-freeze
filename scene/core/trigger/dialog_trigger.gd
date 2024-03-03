class_name Trigger
extends Area2D

@export var checkpoint_id: int = -1
@export var enabled: bool = true
@export var trigger_id: StringName
@export_multiline var dialog_lines: String = ""
@export var random: bool = false
@export var trigger_once: bool = true

var current_dialog: int = 0
var init_enabled: bool = enabled
var dialog_keys: Array[StringName] = []

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	for line in dialog_lines.split("\n", false):
		dialog_keys.append(line)
	reset()


func reset() -> void:
	set_active(init_enabled and GameData.is_checkpoint_passed(checkpoint_id))


func set_active(is_enabled: bool) -> void:
	enabled = is_enabled
	set_deferred("monitoring", enabled)


func _on_body_entered(body: Node2D) -> void:
	if body is Player and enabled:
		if dialog_keys.size() == 0:
			GameData.trigger(trigger_id)
			if trigger_once:
				set_active(false)
		elif random:
			GameData.trigger_dialog(trigger_id, dialog_keys.pick_random())
		else:
			GameData.trigger_dialog(trigger_id, dialog_keys[current_dialog])
			current_dialog += 1
			if current_dialog >= dialog_keys.size() and trigger_once:
				set_active(false)
			current_dialog %= dialog_keys.size()
