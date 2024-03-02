@tool
extends EditorTranslationParserPlugin


func _parse_file(path: String, msgids: Array[String], _msgids_context_plural: Array[Array]):
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	var split_strs = text.split("\n", false)
	for s in split_strs:
		msgids.append(s)


func _get_recognized_extensions():
	return ["trad"]
