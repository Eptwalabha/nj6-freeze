class_name PhoneUI
extends Node2D

enum PhoneScreen {
	NETWORK,
	NEW_MESSAGE,
	READING_MESSAGE,
}

var drawn: bool = false
var target: Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var screen: Sprite2D = %Screen
@onready var position_down: Marker2D = $PositionDown
@onready var pivot: Node2D = $Pivot


func _ready() -> void:
	GameUI.phone_sms_received.connect(_on_message_received)
	toggle(drawn)
	pivot.position = target


func _process(delta: float) -> void:
	pivot.position = pivot.position.slerp(target, delta * GameData.DRAWN_SPEED)


func _check_network() -> void:
	screen.frame = 0


func _on_message_received(_text) -> void:
	set_screen(PhoneScreen.NEW_MESSAGE)
	animation_player.play("new-message")


#func _on_message_opened() -> void:
#	set_screen(PhoneScreen.READING_MESSAGE)
#	animation_player.play("idle")


func set_screen(screen_type: PhoneScreen) -> void:
	match screen_type:
		PhoneScreen.NEW_MESSAGE:
			screen.frame = 1
		PhoneScreen.READING_MESSAGE:
			screen.frame = 2
		_:
			screen.frame = 0


func toggle(is_drawn: bool) -> void:
	drawn = is_drawn
	target = Vector2.ZERO if drawn else position_down.position
