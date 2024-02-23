class_name LvlLabor
extends Node

@onready var parallax: ParallaxBackground = %Parallax
@onready var player: CharacterBody2D = %SideScrollPlayer
@onready var action_label: Label = %ActionLabel
@onready var camera: Camera2D = %PlayerCamera

func _ready() -> void:
	for barrel in get_tree().get_nodes_in_group("barrel"):
		barrel.body_entered.connect(_on_barrel_body_entered)
		barrel.body_exited.connect(_on_barrel_body_exited)

	for interactive : Interactive in get_tree().get_nodes_in_group("interactive"):
		interactive.player_entered.connect(_on_player_in_range.bind(interactive))
		interactive.player_exited.connect(_on_player_out_of_range.bind(interactive))
		interactive.player_interacted.connect(_on_player_interacted.bind(interactive))

func _on_barrel_body_entered(body: Node2D) -> void:
	if body is Player:
		body.heating = true
		print("enter")

func _on_barrel_body_exited(body: Node2D) -> void:
	if body is Player:
		body.heating = false
		print("exit")

func _on_player_in_range(interactive: Interactive) -> void:
	show_action(interactive.item_name)

func _on_player_out_of_range(interactive: Interactive) -> void:
	show_action("")
	interactive.enabled = true

func _on_player_interacted(interactive: Interactive) -> void:
	print("using %s" % interactive.item_name)
	player.set_physics_process(false)
	parallax.visible = false

func show_action(action: String) -> void:
	action_label.visible = (action != "")
	action_label.text = tr(action)

