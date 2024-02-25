class_name GameMap
extends Node2D

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var darkness: PointLight2D = %Darkness

var player : Player

func _ready() -> void:
	darkness.visible = true

func get_player_spawn_point(_index: int) -> Vector2:
	return player_spawn.global_position

func _process(_delta: float) -> void:
	darkness.global_position = player.global_position
