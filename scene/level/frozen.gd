extends Node

enum GameState {
	MENU,
	CUTSCENE,
	DIALOG,
	PLAYING,
}

var phone_visible: bool = false
var dialog_visible: bool = true
var game_states: Array[GameState] = [GameState.PLAYING]

@onready var shadows: Node2D = $Shadows
@onready var player: Player = %Player
@onready var map: GameMap = $FrozenMap
@onready var player_camera: Camera2D = %PlayerCamera
@onready var game_over: GameOverScreen = $GameOver
@onready var final_scene: FinalScreen = $FinalScene
@onready var main_hud: UI = $MainHUD


func _ready() -> void:
	player.global_position = map.get_player_spawn_point(0)
	map.player = player
	player.visible = true
	GameData.game_over.connect(_on_game_over)
	GameData.game_start.connect(_on_game_start)
	GameData.final_scene.connect(_on_final_scene)
	#GameData.phone_drawn.connect(_on_phone_drawn)
	#GameData.phone_hidden.connect(_on_phone_hidden)
	#GameData.phone_message_received.connect(_on_phone_message_received)
	for shadow in get_tree().get_nodes_in_group("shadow"):
		shadow.target = player


func _on_game_over() -> void:
	main_hud.clear()
	GameData.despawn_enemies()
	game_over.play_dead_screen(player.is_looking_left())


func _on_final_scene() -> void:
	main_hud.clear()
	GameData.despawn_enemies()
	final_scene.play_scene()


func _on_game_start() -> void:
	for item in get_tree().get_nodes_in_group("reset"):
		if item.has_method("reset"):
			item.reset()
	map.reset()
	player_camera.make_current()


func _input(event: InputEvent) -> void:
	match game_states[-1]:
		GameState.PLAYING:
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


func push_state(new_state: GameState) -> void:
	game_states.append(new_state)
	match new_state:
		_:
			pass


func pop_state() -> void:
	if len(game_states) == 1:
		return
	match game_states.pop_back():
		GameState.DIALOG:
			GameData.hide_phone()


func _on_phone_drawn() -> void:
	#phone.set_screen(PhoneUI.PhoneScreen.NETWORK)
	toggle_phone_visibility(true)


func _on_phone_hidden() -> void:
	if phone_visible:
		hide_phone()


func _on_phone_message_received(_sms: Array[StringName]) -> void:
	push_state(GameState.DIALOG)
	toggle_phone_visibility(true)


func show_phone() -> void:
	phone_visible = true


func hide_phone() -> void:
	phone_visible = false


func _on_shadow_escaped() -> void:
	GameUI.request_dialog($Shadows/Dialog)
