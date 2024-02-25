class_name Trigger
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var checkpoint_id : int = 0
@export var enabled : bool = true
@export var trigger_id : StringName
@export var dialog_ids : Array[StringName]
@export var random : bool = true
@export var trigger_once : bool = true

var current_dialog : int = 0

var init_enabled : bool = enabled

func _ready() -> void:
	reset()

func reset() -> void:
	var after_checkpoint = (checkpoint_id == -1 or checkpoint_id >= GameData.current_checkpoint_id)
	set_active(init_enabled and after_checkpoint)

func set_active(is_enabled: bool) -> void:
	enabled = is_enabled
	set_deferred("monitoring", enabled)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and enabled:
		if dialog_ids.size() == 0:
			GameData.trigger(trigger_id)
			if trigger_once:
				set_active(false)
		elif random:
			GameData.trigger_dialog(trigger_id, dialog_ids.pick_random())
		else:
			GameData.trigger_dialog(trigger_id, dialog_ids[current_dialog])
			current_dialog += 1
			if current_dialog >= dialog_ids.size() and trigger_once:
				set_active(false)
			current_dialog %= dialog_ids.size()
