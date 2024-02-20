extends Node

var is_music_muted: bool = false
var is_sound_muted: bool = false

var audio : AudioHandler

var scenes : Dictionary = {
	"intro" : preload("res://scene/cutscenes/cs-intro.tscn"),
	"lvl-01" : preload("res://scene/game/lvl-labor.tscn")
}

var current_scene = "intro"

func _ready() -> void:
	audio = preload("res://scene/core/audio.tscn").instantiate()
	add_child(audio)
