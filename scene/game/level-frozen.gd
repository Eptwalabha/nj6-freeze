extends Node

@onready var ui_animation_player: AnimationPlayer = $UI/UIAnimationPlayer
@onready var phone: PhoneUI = $UI/Nokia

var phone_visible : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action-confirm"):
		if phone_visible:
			ui_animation_player.play("phone-hide")
		else:
			ui_animation_player.play("phone-show")
		phone_visible = !phone_visible
