class_name ForceTrigger
extends Area2D

signal forced

@export var context_line: StringName = "SPACE_TO_FORCE"
@export var trigger_id: StringName = ""
@export var enabled: bool = true
@export var health: float = 2.0
@export var face_left: bool = false

var init_health: float = health
var init_enabled: bool = enabled

@onready var health_bar: NinePatchRect = %HealthBar
@onready var health_progress: ColorRect = %HealthProgress


func _ready() -> void:
	health_bar.visible = false
	init_health = health
	init_enabled = enabled
	reset()


func reset() -> void:
	health = init_health
	health_progress.size.x = 0.0
	set_active(init_enabled)


func force_score(score: float) -> void:
	health = max(health - score, 0.0)
	health_progress.size.x = (1.0 - health / init_health) * 12.0
	if health == 0.0:
		GameData.force_trigger_opened.emit(self)
		forced.emit()
		set_active(false)


func set_active(is_enabled: bool) -> void:
	enabled = is_enabled
	set_deferred("monitoring", enabled)


func _on_body_entered(_body: Node2D) -> void:
	health_bar.visible = true
	GameData.force_available(self, true)


func _on_body_exited(_body: Node2D) -> void:
	health_bar.visible = false
	GameData.force_available(self, false)
