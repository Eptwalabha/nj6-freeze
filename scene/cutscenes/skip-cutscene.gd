class_name SkipCutscene
extends Node2D

signal skipped

@export var time_to_skip : float = 2.0
@export var enable : bool = false
@onready var progress: Sprite2D = $Progress

var skip = 0.0
var skipping = false

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if skipping and enable:
		skip = min(time_to_skip, skip + delta)
		if skip >= time_to_skip:
			skip = 0.0
			skipping = false
			skipped.emit()
			enable = false
			visible = false
		progress.scale.x = 13.0 * (skip / time_to_skip)

func _input(event: InputEvent) -> void:
	if not enable:
		return

	if event is InputEventKey :
		if event.is_pressed() and not skipping:
			skip = 0.0
			skipping = true
			visible = true

		if not event.is_pressed():
			skip = 0.0
			skipping = false
			visible = false
