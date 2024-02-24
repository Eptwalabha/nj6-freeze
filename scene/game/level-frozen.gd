extends Node

@onready var ui_animation_player: AnimationPlayer = $UI/UIAnimationPlayer
@onready var phone: PhoneUI = $UI/Nokia
@onready var dialog_ui: DialogUI = $UI/DialogUI

var phone_visible : bool = false
var dialog_visible : bool = true

func _ready() -> void:
	dialog_ui.set_dialog_lines([
		"Welcome to the 6th annual Nokia 3310 Jam! Work solo or make a team to create a game using the restrictions of the original Nokia 3310 phone from the 2000s!",
		"Below you will find the rules, restrictions, and ranking details of the jam. Have fun working within these restrictions! Games that fail to follow these rules will be disqualified from being ranked. For more detailed questions please view the FAQ in the jam's community tab."])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action-confirm"):
		if dialog_visible:
			dialog_ui.next_dialog()
		else:
			toggle_phone_visibility(!phone_visible)

func _on_dialog_ui_dialog_ended() -> void:
	dialog_ui.visible = false
	dialog_visible = false

func _on_dialog_ui_new_line_ended(line_index: Variant) -> void:
	toggle_phone_visibility(line_index >= 1)

func toggle_phone_visibility(is_visible: bool) -> void:
	if is_visible and not phone_visible:
		ui_animation_player.play("phone-show")
	elif not is_visible and phone_visible:
		ui_animation_player.play("phone-hide")
	phone_visible = is_visible
