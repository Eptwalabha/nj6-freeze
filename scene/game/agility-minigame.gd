@tool
extends Node2D

@export var speed : float = 5

@onready var target: Sprite2D = $Range/Target
@onready var cursor: Sprite2D = $Range/Cursor

var time : float = 0.0
var playing : bool = false

func _ready() -> void:
	rand_init()

func _process(delta: float) -> void:
	if playing:
		time += delta * speed
		cursor.position.x = (-cos(time) + 1.0) / 2.0 * 45 + 1

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not playing and event.is_pressed():
			time = 0
			playing = true
			rand_init()
		
		if not event.is_pressed():
			playing = false
			print("delta = %s" %  abs(round(target.position.x - cursor.position.x)))

func rand_init() -> void:
	target.position.x = randi() % 29 + 9
