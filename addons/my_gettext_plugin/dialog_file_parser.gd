@tool
extends EditorTranslationParserPlugin

const DIALOG_KEYS: Array[StringName] = [
	"dialog_lines",
	"context_line",
]


func _parse_file(path: String, msgids: Array[String], _msgids_context_plural: Array[Array]):
	var scene = load(path)
	if scene != null:
		var dialog_lines = _find_trigger(scene.instantiate())
		dialog_lines = dialog_lines.filter(
			func(line: StringName) -> bool: return line.dedent().length() > 0
		)
		msgids.append_array(dialog_lines)


func _get_recognized_extensions():
	return ["tscn"]


func _find_trigger(node: Node) -> Array[StringName]:
	var dialog_ids: Array[StringName] = []
	for child in node.get_children(true):
		if child is Label:
			dialog_ids.append(child.text)
		for key in DIALOG_KEYS:
			dialog_ids.append_array(_extract_dialog_ids(child, key))
		dialog_ids.append_array(_find_trigger(child))
	return dialog_ids


func _extract_dialog_ids(node: Node, key: StringName) -> Array[StringName]:
	var lines: Array[StringName] = []
	if key in node:
		match key:
			"dialog_lines":
				for line in node.dialog_lines.split("\n"):
					lines.append(line)
				return lines
			"context_line":
				lines.append(node.context_line)
	return lines
