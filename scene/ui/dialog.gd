class_name DialogUI
extends Node2D

signal dialog_started
signal dialog_ended
signal new_line_started(line_index)
signal new_line_ended(line_index)

enum DialogState {
	HIDDEN,
	TYPING,
	WAITING,
	DONE,
}

const MAX_CHARACTERS: int = 36
const MAX_CHARACTERS_PER_LINE: int = 18

@export var nbr_letters_per_second: int = 40:
	set = _set_speed

var current_line_index: int = 0
var lines: Array[String] = []
var nbr_lines: int = 0
var char_timer: float = 0.1
var t: float = 0
var state: DialogState = DialogState.HIDDEN

@onready var next_arrow: Sprite2D = $NinePatchRect/NextArrow
@onready var dialog: Label = %Dialog


func stop() -> void:
	state = DialogState.DONE
	lines = []
	current_line_index = 0
	visible = false


func set_dialog_lines(new_lines: Array[StringName], _options: Dictionary = {}) -> void:
	lines = []
	for line in new_lines:
		line = tr(line)
		lines.append_array(DialogUI.split_into_lines(line))
	nbr_lines = len(lines)
	current_line_index = -1
	state = DialogState.HIDDEN


static func split_into_lines(line: String) -> Array[StringName]:
	var p_lines: Array[StringName] = []
	for segment in line.split("\n"):
		if segment.length() <= MAX_CHARACTERS_PER_LINE:
			p_lines.append(segment)
		else:
			var current_line: String = ""
			for letter in segment:
				if (current_line + letter).length() < MAX_CHARACTERS_PER_LINE:
					current_line += letter
				else:
					if letter == " ":
						p_lines.append(current_line)
						current_line = ""
					else:
						var last_space_index: int = current_line.rfind(" ")
						if last_space_index == -1:
							p_lines.append(current_line + letter)
							current_line = ""
						else:
							p_lines.append(current_line.substr(0, last_space_index))
							current_line = current_line.substr(last_space_index + 1) + letter
			if current_line != "":
				p_lines.append(current_line)
	var p_lines2: Array[StringName] = []
	while p_lines.size() > 0:
		if p_lines.size() > 1:
			p_lines2.append(p_lines.pop_front() + "\n" + p_lines.pop_front())
		else:
			p_lines2.append(p_lines.pop_front())
	return p_lines2


func _process(delta: float) -> void:
	if state == DialogState.TYPING:
		t -= delta
		if t < 0:
			t += char_timer
			dialog.visible_characters += 1
			if dialog.visible_ratio >= 1.0:
				_end_of_line()


func next_dialog() -> void:
	if nbr_lines == 0:
		return
	if state == DialogState.DONE:
		stop()
		dialog_ended.emit()
	if state == DialogState.TYPING:
		dialog.visible_characters = -1
		_end_of_line()
	elif state == DialogState.DONE:
		visible = false
		state = DialogState.HIDDEN
	elif (current_line_index + 1) >= nbr_lines:
		return
	else:
		next_arrow.visible = false
		current_line_index += 1
		dialog.visible_characters = 0
		dialog.text = tr(lines[current_line_index])
		new_line_started.emit(current_line_index)
		if state == DialogState.HIDDEN:
			dialog_started.emit()
			GameData.open_sms()
			visible = true
		state = DialogState.TYPING


func _end_of_line() -> void:
	if current_line_index < (nbr_lines - 1):
		state = DialogState.WAITING
		next_arrow.visible = true
	else:
		state = DialogState.DONE
		next_arrow.visible = false
	new_line_ended.emit(current_line_index)


func _set_speed(new_nbr_letters_per_second: int) -> void:
	nbr_letters_per_second = new_nbr_letters_per_second
	char_timer = 1.0 / float(nbr_letters_per_second)
