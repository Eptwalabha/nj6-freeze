@tool
extends EditorTranslationParserPlugin

const DIALOG_KEYS: Array[StringName] = [
	"dialog_ids",
	"context",
]


func _parse_file(path: String, msgids: Array[String], _msgids_context_plural: Array[Array]):
	var scene = load(path)
	if scene != null:
		var dialog_ids = _find_trigger(scene.instantiate())
		msgids.append_array(dialog_ids)


func _get_recognized_extensions():
	return ["tscn"]


func _find_trigger(node: Node) -> Array[StringName]:
	var dialog_ids: Array[StringName] = []
	for child in node.get_children(true):
		for key in DIALOG_KEYS:
			dialog_ids.append_array(_extract_dialog_ids(child, key))
		dialog_ids.append_array(_find_trigger(child))
	return dialog_ids


func _extract_dialog_ids(node: Node, key: StringName) -> Array[StringName]:
	if key in node:
		match key:
			"dialog_ids":
				return node.dialog_ids
			"context":
				return [node.context]
	return []
