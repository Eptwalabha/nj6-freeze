class_name UI
extends CanvasLayer

@onready var ui_context: Label = %UIContext
@onready var context_bar: NinePatchRect = $ContextBar
@onready var agility: Node2D = $Agility
@onready var dialog_ui: DialogUI = $DialogUI


func _ready() -> void:
	context_bar.visible = false
	agility.visible = false
	GameUI.dialog_requested.connect(_on_dialog_requested)
	GameUI.dialog_stopped.connect(_on_dialog_stopped)
	GameUI.dialog_next_line_requested.connect(_on_next_line_requested)

	GameData.ui_context_hidden.connect(_on_context_hidden)
	GameData.ui_context_requested.connect(_on_context_requested)
	GameData.ui_agility_pressed.connect(_on_context_hidden)


func clear() -> void:
	dialog_ui.stop()
	context_bar.visible = false


func _on_dialog_requested(dialog_lines: Array[StringName]) -> void:
	print(dialog_lines)
	dialog_ui.set_dialog_lines(dialog_lines)
	dialog_ui.next_dialog()


func _on_dialog_stopped() -> void:
	dialog_ui.visible = false


func _on_next_line_requested() -> void:
	dialog_ui.next_dialog()


func _on_context_hidden() -> void:
	context_bar.visible = false


func _on_context_requested(message: StringName) -> void:
	ui_context.text = tr(message)
	context_bar.visible = true
