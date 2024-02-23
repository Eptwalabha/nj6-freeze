extends Node2D

@onready var mercury: Sprite2D = %Mercury

func _ready() -> void:
	GameData.temperature_changed.connect(_on_temperature_changed)
	
func _on_temperature_changed(new_temp : float) -> void:
	mercury.scale.y = clamp(new_temp, 0.0, 100.0) / 100.0 * 36.0
