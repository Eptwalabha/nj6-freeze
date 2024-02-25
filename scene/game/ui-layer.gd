class_name UI
extends CanvasLayer

@onready var ui_context: Label = %UIContext
@onready var context_bar: NinePatchRect = $ContextBar
@onready var agility: Node2D = $Agility

func _ready() -> void:
	context_bar.visible = false
	agility.visible = false
	GameData.ui_context_hidden.connect(_on_context_hidden)
	GameData.ui_context_requested.connect(_on_context_requested)
	GameData.ui_agility_pressed.connect(_on_context_hidden)

func _on_context_hidden() -> void:
	context_bar.visible = false

func _on_context_requested(message: StringName) -> void:
	ui_context.text = tr(message)
	context_bar.visible = true
