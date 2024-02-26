class_name Car
extends Node2D

signal battery_died

@onready var trunk: Sprite2D = $Car/Trunk
@onready var car_outline: Sprite2D = $CarOutline
@onready var light: Node2D = $Light
@onready var car: Sprite2D = $Car

func _ready() -> void:
	reset()
	GameData.flashlight_found.connect(_player_found_light)
	trunk.visible = false
	car_outline.visible = false

func reset() -> void:
	car.visible = true
	car_outline.visible = false
	var is_checkpoint_passed = GameData.is_checkpoint_passed(1)
	trunk.visible = is_checkpoint_passed
	light.visible = not is_checkpoint_passed
	$ForceTrunk.set_active(not is_checkpoint_passed)

func _on_node_2d_forced() -> void:
	trunk.visible = true
	await get_tree().create_timer(2.0).timeout
	car_outline.visible = true
	car.visible = false
	light.visible = false
	GameData.car_battery_died()
	battery_died.emit()

func _player_found_light() -> void:
	car.visible = true
	car_outline.visible = false
