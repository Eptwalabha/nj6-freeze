class_name GameMap
extends Node2D

var player: Player

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var darkness: PointLight2D = %Darkness
@onready var tutorial_boundary: CollisionShape2D = %TutorialBoundary
@onready var markers = $Map/Markers


func _ready() -> void:
	darkness.visible = true
	GameData.flashlight_found.connect(
		func () -> void:
			tutorial_boundary.set_deferred("disabled", true)
	)


func reset() -> void:
	tutorial_boundary.set_deferred("disabled", GameData.current_checkpoint_id > 0)
	$Triggers/Dialogs/TooDark.set_active(GameData.current_checkpoint_id == 0)


func get_player_spawn_point(_index: int) -> Vector2:
	return player_spawn.global_position


func _process(_delta: float) -> void:
	darkness.global_position = player.global_position


func _on_car_battery_died() -> void:
	$Triggers/Dialogs/TooDark.set_active(false)


func get_marker_position(marker_id: StringName) -> Vector2:
	for marker in markers.get_children():
		if marker.has_meta("id") and marker.get_meta("id") == marker_id:
			return marker.global_position
	return Vector2.ZERO
