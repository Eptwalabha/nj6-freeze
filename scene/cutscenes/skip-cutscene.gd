class_name SkipCutscene
extends Node2D

signal skipped

@export var time_to_skip : float = 1.0
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
			skipped.emit()
			enable = false
			set_visibility(false)
		progress.scale.x = 13.0 * (skip / time_to_skip)

func _input(event: InputEvent) -> void:
	if not enable:
		return

	if event is InputEventKey :
		if event.is_pressed() and not skipping:
			set_visibility(true)

		if not event.is_pressed():
			set_visibility(false)

func set_visibility(is_skip_visible: bool) -> void:
	skip = 0.0
	skipping = is_skip_visible
	visible = is_skip_visible
