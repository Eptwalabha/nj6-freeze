extends Node

@onready var ui_animation_player: AnimationPlayer = $UI/UIAnimationPlayer
@onready var phone: PhoneUI = $UI/Nokia
@onready var dialog_ui: DialogUI = $UI/DialogUI
@onready var shadows: Node2D = $Shadows
@onready var player: Player = %Player
@onready var darkness: PointLight2D = $Darkness
@onready var map: GameMap = $FrozenMap

var phone_visible : bool = false
var dialog_visible : bool = true

enum GAME_STATE {
	MENU,
	CUTSCENE,
	DIALOG,
	PLAYING
}

var game_states : Array[GAME_STATE] = [GAME_STATE.PLAYING]

func _ready() -> void:
	player.global_position = map.get_player_spawn_point()
	map.player = player
	player.visible = true
	GameData.phone_drawn.connect(_on_phone_drawn)
	GameData.phone_hidden.connect(_on_phone_hidden)
	GameData.phone_message_received.connect(_on_phone_message_received)
	for shadow in get_tree().get_nodes_in_group("shadow"):
		shadow.target = player


func _input(event: InputEvent) -> void:
	match game_states[-1]:
		GAME_STATE.DIALOG:
			if event.is_action_pressed("action-confirm") and dialog_visible:
				dialog_ui.next_dialog()
		GAME_STATE.PLAYING:
			if event.is_action_pressed("move_up"):
				GameData.show_phone()
			if event.is_action_pressed("move_down"):
				GameData.hide_phone()
		_:
			pass

func _on_dialog_ui_dialog_ended() -> void:
	pop_state()

func _on_dialog_ui_new_line_ended(line_index: Variant) -> void:
	if line_index == 1:
		toggle_phone_visibility(true)

func toggle_phone_visibility(is_visible: bool) -> void:
	if is_visible and not phone_visible:
		show_phone()
	elif not is_visible and phone_visible:
		hide_phone()

func _on_timer_timeout() -> void:
	var text : Array[String] = [
		"test line 1\ntest line 2\ntest line 3\ntest line 4\ntest line 5",
		#"Welcome to the 6th annual Nokia 3310 Jam! Work solo or make a team to create a game using the restrictions of the original Nokia 3310 phone from the 2000s!",
		#"Below you will find the rules, restrictions, and ranking details of the jam. Have fun working within these restrictions! Games that fail to follow these rules will be disqualified from being ranked. For more detailed questions please view the FAQ in the jam's community tab.",
	]
	GameData.new_sms(text)

func push_state(new_state: GAME_STATE) -> void:
	game_states.append(new_state)
	match new_state:
		_:
			pass

func pop_state() -> void:
	if len(game_states) == 1:
		return
	# do things with poped state
	match game_states.pop_back():
		GAME_STATE.DIALOG:
			GameData.hide_phone()

func _on_phone_drawn() -> void:
	phone.set_screen(PhoneUI.SCREEN.NETWORK)
	toggle_phone_visibility(true)

func _on_phone_hidden() -> void:
	hide_phone()

func _on_phone_message_received(sms: Array[String]) -> void:
	dialog_ui.set_dialog_lines(sms)
	push_state(GAME_STATE.DIALOG)
	toggle_phone_visibility(true)

func show_phone() -> void:
	phone_visible = true
	ui_animation_player.play("phone-show")

func hide_phone() -> void:
	phone_visible = false
	ui_animation_player.play("phone-hide")
