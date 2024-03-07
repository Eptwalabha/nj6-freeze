class_name FinalScreen
extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialog: Dialog = $Dialog/Dialog


func _ready() -> void:
	set_process_input(false)
	GameData.dialog_started.connect(_on_dialog_started)
	GameData.dialog_ended.connect(_on_dialog_ended)


func play_scene() -> void:
	animation_player.play("intro")
	camera_2d.make_current()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"intro":
			GameUI.request_dialog(dialog)


func _on_dialog_started(dialog_id: StringName) -> void:
	if dialog.dialog_id == dialog_id:
		animation_player.play("talk")


func _on_dialog_ended(dialog_id: StringName) -> void:
	if dialog.dialog_id == dialog_id:
		animation_player.play("eating")
