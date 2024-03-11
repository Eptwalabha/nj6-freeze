class_name GameLevel
extends Node

enum GameState {
	MENU,
	CUTSCENE,
	DIALOG,
	PLAYING,
}

const SHADOW_ENEMY = preload("res://scene/entities/shadow.tscn")

var phone_visible: bool = false
var dialog_visible: bool = true
var current_game_state: GameState = GameState.PLAYING

@onready var player: Player = %Player
@onready var map: GameMap = $Map
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
	GameData.game_start.emit()


func _on_game_over() -> void:
	main_hud.clear()
	current_game_state = GameState.CUTSCENE
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
	player.global_position = map.get_player_spawn_point(0)
	player_camera.make_current()
	current_game_state = GameState.PLAYING


func _input(event: InputEvent) -> void:
	match current_game_state:
		GameState.PLAYING:
			if event.is_action_pressed("move_up"):
				GameData.show_phone()
			if event.is_action_pressed("move_down"):
				GameData.hide_phone()
		_:
			pass


func _on_dialog_ui_new_line_ended(_line_index: Variant) -> void:
	pass


func spawn_enemy_at(marker_id: StringName) -> ShadowEnemy:
	var enemy_position: Vector2 = map.get_marker_position(marker_id)
	var enemy: ShadowEnemy = SHADOW_ENEMY.instantiate()
	map.add_child(enemy)
	enemy.global_position = enemy_position
	return enemy
