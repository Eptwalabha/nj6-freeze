extends Node

signal temperature_changed(temp)

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
