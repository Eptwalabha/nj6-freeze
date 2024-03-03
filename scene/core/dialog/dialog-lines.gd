class_name Dialog
extends Node

@export_multiline var dialog_lines: String = ""

var dialog_keys: Array[StringName] = []


func _ready() -> void:
	for line in dialog_lines.split("\n", false):
		dialog_keys.append(line)
