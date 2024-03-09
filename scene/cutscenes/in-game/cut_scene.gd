class_name CutScene
extends Node

signal cut_scene_stated(cut_scene_id)
signal cut_scene_ended(cut_scene_id)

@export var cut_scene_id: StringName = ""

var level: GameLevel


func _ready() -> void:
	if cut_scene_id == "":
		cut_scene_id = name
	level = owner


func start() -> void:
	cut_scene_stated.emit(cut_scene_id)


func end() -> void:
	cut_scene_ended.emit(cut_scene_id)
