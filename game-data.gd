extends Node

var is_music_muted: bool = false
var is_sound_muted: bool = false

var audio : AudioHandler

func _ready() -> void:
	audio = preload("res://scene/core/audio.tscn").instantiate()
	add_child(audio)
