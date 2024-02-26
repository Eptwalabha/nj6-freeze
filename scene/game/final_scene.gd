class_name FinalScreen
extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var dialog_ui: DialogUI = $DialogUI
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	set_process_input(false)

func play_scene() -> void:
	animation_player.play("intro")
	camera_2d.make_current()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action-confirm"):
		dialog_ui.next_dialog()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"intro":
			dialog_ui.set_dialog_lines([
				"HELLO",
				"NICE TO MEET YOU\nI'AM BOB",
				"THANK YOU FOR NOT DYING OF COLD",
				"...",
				"I REALLY DON'T LIKE FROZEN MEAT"])
			set_process_input(true)
			dialog_ui.next_dialog()
		"eating":
			print("credit")

func _on_dialog_ui_dialog_ended() -> void:
	animation_player.play("eating")

func _on_dialog_ui_new_line_started(line_index: Variant) -> void:
	animation_player.play("talk")
