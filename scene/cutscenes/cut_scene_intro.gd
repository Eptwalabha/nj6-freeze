class_name CutSceneIntro
extends CutScene

var shade: ShadowEnemy

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	super()
	GameData.triggered.connect(_on_triggered_emited)


func start() -> void:
	level.reset_player_position()
	level.player.enters_cutscene(true)
	level.player.get_up()
	await get_tree().create_timer(1.5).timeout
	GameUI.request_dialog($Dialogs/PlayerWakesUp)
	await GameData.dialog_ended
	level.player.enters_cutscene(false)


func _on_triggered_emited(trigger_id: StringName) -> void:
	if trigger_id == &"car_battery_died":
		car_battery_died()


func car_battery_died() -> void:
	level.player.enters_cutscene(true)
	await get_tree().create_timer(0.5).timeout
	GameUI.request_dialog($Dialogs/CarBatteryIsDead)
	await GameData.dialog_ended
	level.player.looks_left(false)
	shade = level.spawn_enemy_at("tutorial_spawner")
	shade.global_position = level.player.global_position + Vector2(60.0, 0.0)
	shade.target = level.player
	shade.activate()
	shade.escaped.connect(_on_first_shade_escaped)
	await get_tree().create_timer(2.2).timeout
	GameData.flashlight_found.emit()


func _on_first_shade_escaped() -> void:
	GameUI.request_dialog($Dialogs/FirstEncounter)
	await GameData.dialog_ended
	level.player.enters_cutscene(false)
