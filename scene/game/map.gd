class_name GameMap
extends Node2D

var player: Player

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var darkness: PointLight2D = %Darkness
@onready var tutorial_boundary: CollisionShape2D = %TutorialBoundary


func _ready() -> void:
	darkness.visible = true


func reset() -> void:
	tutorial_boundary.set_deferred("disabled", GameData.current_checkpoint_id > 0)
	$Triggers/Dialogs/TooDark.set_active(GameData.current_checkpoint_id == 0)


func get_player_spawn_point(_index: int) -> Vector2:
	return player_spawn.global_position


func _process(_delta: float) -> void:
	darkness.global_position = player.global_position


func _on_car_battery_died() -> void:
	tutorial_boundary.set_deferred("disabled", true)
	$Triggers/Dialogs/TooDark.set_active(false)
