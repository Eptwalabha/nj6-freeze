extends Node2D

@onready var bridge: CollisionShape2D = $Bridge/Bridge
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_force_trigger_forced() -> void:
	animation_player.play("lower-the-bridge")

func allow_passage() -> void:
	bridge.set_deferred("disabled", true)
