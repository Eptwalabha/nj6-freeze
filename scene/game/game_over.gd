class_name GameOverScreen
extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dead_player: Sprite2D = $Node2D/DeadPlayer

func _ready() -> void:
	set_process_input(false)

func play_dead_screen(flip: bool) -> void:
	dead_player.flip_h = flip
	set_process_input(false)
	animation_player.play("player-died")
	camera_2d.make_current()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action-confirm"):
		set_process_input(false)
		GameData.reload_game()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "player-died":
		animation_player.play("press-space")
		set_process_input(true)
