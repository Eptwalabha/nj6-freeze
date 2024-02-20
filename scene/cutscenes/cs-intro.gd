class_name CS_intro
extends Node

signal load_next_level(next_level)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var title: Node2D = $Title
@onready var spawn_inmate: Timer = $Timer
@onready var bus_door: Marker2D = $Bus/BusDoor
@onready var inmates: Node2D = $Inmates
@export var inmate_to_spawn : int = 6
@onready var skip: SkipCutscene = $Skip

var Inmate = preload("res://scene/cutscenes/tiny-human.tscn")
var main_menu = true

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and main_menu:
		main_menu = false
		title.visible = false
		skip.enable = true
		animation_player.play("intro")

func start_spawning_inmate() -> void:
	spawn_inmate.start()

func _on_timer_timeout() -> void:
	var inmate : TinyInmate = Inmate.instantiate()
	inmates.add_child(inmate)
	inmate.global_position = bus_door.global_position
	inmate.move_to(bus_door.global_position + Vector2(50.0, 0.0))
	inmate_to_spawn -= 1
	if inmate_to_spawn > 0:
		spawn_inmate.start(1.5 + randf() * 2.0)
	else:
		load_next_level.emit("lvl-01")

func _on_skip_skipped() -> void:
	load_next_level.emit("lvl-01")
	
