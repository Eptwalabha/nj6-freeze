class_name CutSceneIntro
extends CutScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var shade : ShadowEnemy

func _ready() -> void:
	super._ready()
	GameData.triggered.connect(_on_triggered_emited)


func _on_triggered_emited(trigger_id: StringName) -> void:
	if trigger_id == "car_battery_died":
		level.player.enters_cutscene(true)
		level.player.looks_left(false)
		animation_player.play("intro")


func battery_car_dies_out() -> void:
	shade = level.spawn_enemy_at("tutorial_spawner")
	shade.global_position = level.player.global_position + Vector2(60.0, 0.0)
	shade.target = level.player
	shade.activate()
	shade.escaped.connect(GameUI.request_dialog.bind($Dialogs/FirstEncounter))
	await get_tree().create_timer(2.5).timeout
	level.player.enters_cutscene(false)
	GameData.flashlight_found.emit()
