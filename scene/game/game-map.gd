extends Node

@onready var ui_animation_player: AnimationPlayer = $UI/UIAnimationPlayer
@onready var phone: PhoneUI = $UI/Nokia
@onready var dialog_ui: DialogUI = $UI/DialogUI
@onready var shadows: Node2D = $Shadows
@onready var player: Player = %Player
@onready var map: GameMap = $FrozenMap
@onready var player_camera: Camera2D = %PlayerCamera
@onready var game_over: GameOverScreen = $GameOver
@onready var final_scene: FinalScreen = $FinalScene

@onready var ui: CanvasLayer = $UI

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
	player.global_position = map.get_player_spawn_point(0)
	map.player = player
	player.visible = true
	GameData.game_over.connect(_on_game_over)
	GameData.game_start.connect(_on_game_start)
	GameData.final_scene.connect(_on_final_scene)
	GameData.phone_drawn.connect(_on_phone_drawn)
	GameData.phone_hidden.connect(_on_phone_hidden)
	GameData.phone_message_received.connect(_on_phone_message_received)
	GameData.dialog_triggered.connect(_on_dialog_triggered)
	for shadow in get_tree().get_nodes_in_group("shadow"):
		shadow.target = player

func _on_game_over() -> void:
	ui.visible = false
	GameData.despawn_enemies()
	game_over.play_dead_screen(player.is_looking_left())

func _on_final_scene() -> void:
	ui.visible = false
	GameData.despawn_enemies()
	final_scene.play_scene()

func _on_game_start() -> void:
	ui.visible = true
	for item in get_tree().get_nodes_in_group("reset"):
		if item.has_method("reset"):
			item.reset()
	map.reset()
	player_camera.make_current()

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

func _on_dialog_ui_new_line_ended(_line_index: Variant) -> void:
	pass

func toggle_phone_visibility(is_visible: bool) -> void:
	if is_visible and not phone_visible:
		show_phone()
	elif not is_visible and phone_visible:
		hide_phone()

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
	if phone_visible:
		hide_phone()

func _on_phone_message_received(sms: Array[String]) -> void:
	dialog_ui.set_dialog_lines(sms)
	push_state(GAME_STATE.DIALOG)
	toggle_phone_visibility(true)

func _on_dialog_triggered(dialog: String) -> void:
	dialog_ui.set_dialog_lines([dialog])
	push_state(GAME_STATE.DIALOG)
	dialog_ui.next_dialog()

func show_phone() -> void:
	phone_visible = true
	ui_animation_player.play("phone-show")

func hide_phone() -> void:
	phone_visible = false
	ui_animation_player.play("phone-hide")

func _on_shadow_escaped() -> void:
	GameData.dialog_triggered.emit("what was that?")
