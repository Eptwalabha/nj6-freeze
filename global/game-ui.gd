extends Node

signal action_context_shown(action_context)
signal action_context_hidden

signal dialog_requested(dialog_keys)
#signal dialog_triggered(dialog_key)
signal dialog_next_line_requested
signal dialog_stopped

signal phone_drawn
signal phone_hidden
signal phone_sms_received


func request_dialog(dialog: Dialog) -> void:
	dialog_requested.emit(dialog.dialog_keys)


func request_dialog_line(line: StringName) -> void:
	dialog_requested.emit([line] as Array[StringName])


func hide_dialog() -> void:
	dialog_stopped.emit()


func next_dialog_line() -> void:
	dialog_next_line_requested.emit()


func show_action_context(action_context: StringName) -> void:
	action_context_shown.emit(action_context)


func hide_action_context() -> void:
	action_context_hidden.emit()


func show_phone() -> void:
	phone_drawn.emit()


func hide_phone() -> void:
	phone_hidden.emit()
