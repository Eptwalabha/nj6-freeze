class_name PhoneUI
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var network_status: Sprite2D = $Nokia/Screen/NoNetwork
@onready var new_message: Sprite2D = $Nokia/Screen/NewMessage

func _ready() -> void:
	GameData.new_message_received.connect(_on_new_message_received)

func _check_network() -> void:
	new_message.visible = false
	network_status.visible = true

func _on_new_message_received() -> void:
	animation_player.play("new-message")
