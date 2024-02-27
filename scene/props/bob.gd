class_name Bob
extends Node2D

signal player_grabbed

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hand: Sprite2D = $Hand
@onready var torch: PointLight2D = $Hand/Torch


func _ready() -> void:
	hand.visible = false
	GameData.bob_arrived.connect(grab)


func grab() -> void:
	animation_player.play("grab")


func grabbed() -> void:
	player_grabbed.emit()
	GameData.player_grabbed_by_bob.emit()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	GameData.final_scene.emit()
