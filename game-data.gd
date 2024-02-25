extends Node

signal temperature_changed(temp)

signal phone_message_received(dialog)
signal phone_message_opened
signal phone_change_screen(screen_name)
signal phone_drawn
signal phone_hidden

var is_music_muted: bool = false
var is_sound_muted: bool = false

var audio : AudioHandler

var scenes : Dictionary = {
	"intro" : preload("res://scene/cutscenes/cs-intro.tscn"),
	"lvl-01" : preload("res://scene/game/lvl-labor.tscn")
}

var current_scene = "intro"

var collectible_items = {
	"wooden_shard": false,
	"tin_metal_shard": false,
	"rail_nail": false,
	"empty_lighter": false,
	"painkiller": false
}

var affinity = {
	"prisonner": 0.0,
	"guards": 0.0,
}

var player_stats = {
	"stamina": 100,
	"health": 100,
	"cold": 0,
	"fever": false,
}

func _ready() -> void:
	audio = preload("res://scene/core/audio.tscn").instantiate()
	add_child(audio)

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
	if dialog_id == "lol":
		new_sms(["salut la forme?\ntoto"])
