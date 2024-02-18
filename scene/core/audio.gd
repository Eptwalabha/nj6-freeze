class_name AudioHandler
extends Node

@onready var music: AudioStreamPlayer = $Music
@onready var sound: AudioStreamPlayer = $Sound

var streams = {
	"Hit1": preload("res://assets/sounds/hit1.wav"),
	"Hit2": preload("res://assets/sounds/hit2.wav")
}

func play_sound(sound_name: String) -> void:
	sound.stream = streams[sound_name]
	_play_sound()

func play_music(music_name: String) -> void:
	music.stream = streams[music_name]
	music.play()

func _play_sound() -> void:
	AudioServer.set_bus_solo(1, false)
	AudioServer.set_bus_solo(2, true)
	sound.play()

func _on_sound_finished() -> void:
	AudioServer.set_bus_solo(1, true)
	AudioServer.set_bus_solo(2, false)
