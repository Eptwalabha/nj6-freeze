extends Node

signal temperature_changed(temp)

signal dialog_triggered(dialog)

signal phone_message_received(dialog)
signal phone_message_opened
signal phone_change_screen(screen_name)
signal phone_drawn
signal phone_hidden

signal game_start
signal game_over

signal ui_context_requested(message)
signal ui_context_hidden

signal force_trigger_entered(trigger)
signal force_trigger_exited
signal force_trigger_opened(trigger)

signal ui_agility_pressed
signal ui_agility_released
signal ui_agility_score(score)

signal flashlight_found

var audio : AudioHandler
var is_music_muted: bool = false
var is_sound_muted: bool = false

var current_checkpoint_id : int = 0

var active_force_trigger: ForceTrigger

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
	match trigger_id:
		"dialog-player":
			dialog_triggered.emit(dialog_id)
		"dialog-phone":
			new_sms([dialog_id])

func force_available(trigger: ForceTrigger, available: bool) -> void:
	if available:
		active_force_trigger = trigger
		force_trigger_entered.emit(trigger)
		ui_context_requested.emit("force_available")
	else:
		force_trigger_exited.emit()
		ui_context_hidden.emit()

func current_force_score(score: float) -> void:
	if active_force_trigger != null:
		active_force_trigger.force_score(score)
	GameData.ui_agility_score.emit(score)

func car_battery_died() -> void:
	await get_tree().create_timer(2.0).timeout
	flashlight_found.emit()
