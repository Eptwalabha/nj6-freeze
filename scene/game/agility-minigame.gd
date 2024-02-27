extends Node2D

@export var speed : float = 5

var time : float = 0.0

@onready var target: Sprite2D = $Range/Target
@onready var cursor: Sprite2D = $Range/Cursor

func _ready() -> void:
	visible = false
	set_process(false)
	GameData.ui_agility_pressed.connect(_on_agility_start)
	GameData.ui_agility_released.connect(_on_agility_end)
	rand_init()

func _process(delta: float) -> void:
	time += delta * speed
	cursor.position.x = (-cos(time) + 1.0) / 2.0 * 45 + 1

func rand_init() -> void:
	target.position.x = randi() % 29 + 9

func _on_agility_start() -> void:
	rand_init()
	visible = true
	set_process(true)
	time = 0.0

func _on_agility_end() -> void:
	visible = false
	set_process(false)
	var dist : int = abs(round(target.position.x - cursor.position.x))
	var score = 0.0
	if dist <= 3:
		score = 1.0
	elif dist < 10:
		score = 0.5
	GameData.current_force_score(score)
