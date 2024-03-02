@tool
extends EditorPlugin

var trad_file_parser = preload("res://addons/my_gettext_plugin/trad_file_parser.gd")
var dialog_file_parser = preload("res://addons/my_gettext_plugin/dialog_file_parser.gd")


func _enter_tree() -> void:
	add_translation_parser_plugin(trad_file_parser.new())
	add_translation_parser_plugin(dialog_file_parser.new())
