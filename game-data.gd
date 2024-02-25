extends Node

signal temperature_changed(temp)

signal phone_message_received(dialog)
signal phone_message_opened
signal phone_change_screen(screen_name)
signal phone_drawn
signal phone_hidden

signal game_start
signal game_over

var audio : AudioHandler
var is_music_muted: bool = false
var is_sound_muted: bool = false

var current_checkpoint_id : int = 0

func _ready() -> void:
	audio = preload("res://scene/core/audio.tscn").instantiate()
	add_child(audio)

func reload_game() -> void:
	game_start.emit()

func new_sms(text: Array[String]) -> void:
	phone_message_received.emit(text)

func open_sms() -> void:
	phone_message_opened.emit()

func show_phone() -> void:
	phone_drawn.emit()

func hide_phone() -> void:
	phone_hidden.emit()

func trigger_dialog(trigger_id: StringName, dialog_id: StringName) -> void:
	print("trigger %s dialog_id %s" % [trigger_id, dialog_id])
	if dialog_id == "intro-cliff":
		game_over.emit()
		#new_sms(["salut la forme?\ntoto"])
