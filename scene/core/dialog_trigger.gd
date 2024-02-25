class_name Trigger
extends Area2D

@export var enable : bool = true
@export var trigger_id : StringName
@export var dialog_ids : Array[StringName]
@export var random : bool = true
@export var trigger_once : bool = true

var current_dialog : int = 0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if dialog_ids.size() == 0:
			GameData.trigger(trigger_id)
			if trigger_once:
				queue_free()
		elif random:
			GameData.trigger_dialog(trigger_id, dialog_ids.pick_random())
		else:
			GameData.trigger_dialog(trigger_id, dialog_ids[current_dialog])
			current_dialog += 1
			if current_dialog >= dialog_ids.size() and trigger_once:
				queue_free()
			current_dialog %= dialog_ids.size()
