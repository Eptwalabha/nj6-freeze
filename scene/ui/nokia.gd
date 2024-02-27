class_name PhoneUI
extends Node2D

enum PhoneScreen {
	NETWORK,
	NEW_MESSAGE,
	READING_MESSAGE,
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var screen: Sprite2D = $Nokia/Screen

func _ready() -> void:
	GameData.phone_message_received.connect(_on_message_received)
	GameData.phone_message_opened.connect(_on_message_opened)

func _check_network() -> void:
	screen.frame = 0

func _on_message_received(_text) -> void:
	set_screen(PhoneScreen.NEW_MESSAGE)
	animation_player.play("new-message")

func _on_message_opened() -> void:
	set_screen(PhoneScreen.READING_MESSAGE)
	animation_player.play("idle")

func set_screen(screen_type: PhoneScreen) -> void:
	match screen_type:
		PhoneScreen.NEW_MESSAGE:
			screen.frame = 1
		PhoneScreen.READING_MESSAGE:
			screen.frame = 2
		_:
			screen.frame = 0
