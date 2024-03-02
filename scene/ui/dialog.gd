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

const MAX_CHARACTERS: int = 34
const MAX_CHARACTERS_PER_LINE: int = 17

@export var nbr_letters_per_second: int = 40:
	set = _set_speed

var current_line_index: int = 0
var lines: Array[String] = []
var nbr_lines: int = 0
var char_timer: float = 0.1
var t: float = 0
var state: DialogState = DialogState.HIDDEN

@onready var next_arrow: Sprite2D = $NinePatchRect/NextArrow
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialog: Label = %Dialog


func set_dialog_lines(new_lines: Array[String], _options: Dictionary = {}) -> void:
	lines = []
	for line in new_lines:
		lines.append_array(_split_line(line))
	nbr_lines = len(lines)
	current_line_index = -1


func _split_line(line: String) -> Array[String]:
	var lines_acc: Array[String] = []
	var current_line: String = ""
	var current_word: String = ""
	for letter in line:
		current_word += letter
		if letter == "\n":
			current_line += current_word
			lines_acc.append(current_line)
			current_word = ""
			current_line = ""
		if letter == " ":
			if len(current_line) > MAX_CHARACTERS_PER_LINE:
				lines_acc.append(current_line)
				current_line = ""
			current_line += current_word
			current_word = ""
		else:
			if len(current_line + current_word) > MAX_CHARACTERS_PER_LINE:
				lines_acc.append(current_line)
				current_line = ""
	current_line += current_word
	if len(current_line) > 0:
		lines_acc.append(current_line)
	var final_lines: Array[String] = []
	var line_count: int = 0
	current_line = ""
	for line_acc in lines_acc:
		current_line += line_acc
		line_count += 1
		if line_count > 1:
			line_count = 0
			final_lines.append(current_line)
			current_line = ""
	if len(lines_acc) % 2 == 1:
		final_lines.append(lines_acc[-1])
	return final_lines


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
		visible = false
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
