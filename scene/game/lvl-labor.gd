class_name LvlLabor
extends Node

@onready var parallax: ParallaxBackground = $ParallaxBackground
@onready var player: CharacterBody2D = $ParallaxBackground/ParallaxLayer/Player
@onready var action_label: Label = %ActionLabel

var working : bool = false
var ready_to_work : bool = false

func _ready() -> void:
	for barrel in get_tree().get_nodes_in_group("barrel"):
		barrel.body_entered.connect(_on_barrel_body_entered)
		barrel.body_exited.connect(_on_barrel_body_exited)

func _process(_delta: float) -> void:
	parallax.scroll_offset.x = clamp(-(player.position.x - 42.0), -336+84, 0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action-confirm"):
		if ready_to_work and not player.working:
			print("working")
			player.working = true

func _on_barrel_body_entered(body: Node2D) -> void:
	if body is Player:
		body.heating = true

func _on_barrel_body_exited(body: Node2D) -> void:
	if body is Player:
		body.heating = false

func _on_pickaxe_body_entered(body: Node2D) -> void:
	if body is Player:
		show_action("action_work")
		ready_to_work = true

func _on_pickaxe_body_exited(body: Node2D) -> void:
	if body is Player:
		show_action("")
		ready_to_work = false

func show_action(action: String) -> void:
	action_label.visible = (action != "")
	action_label.text = tr(action)

