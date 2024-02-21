class_name LvlLabor
extends Node

@onready var parallax: ParallaxBackground = $ParallaxBackground
@onready var player: CharacterBody2D = $ParallaxBackground/ParallaxLayer/Player
@onready var action_label: Label = %ActionLabel

func _ready() -> void:
	for barrel in get_tree().get_nodes_in_group("barrel"):
		barrel.body_entered.connect(_on_barrel_body_entered)
		barrel.body_exited.connect(_on_barrel_body_exited)

	for interactive : Interactive in get_tree().get_nodes_in_group("interactive"):
		interactive.player_entered.connect(_on_player_in_range.bind(interactive))
		interactive.player_exited.connect(_on_player_out_of_range.bind(interactive))
		interactive.player_interacted.connect(_on_player_interacted.bind(interactive))

func _process(_delta: float) -> void:
	parallax.scroll_offset.x = clamp(-(player.position.x - 42.0), -336+84, 0)

func _on_barrel_body_entered(body: Node2D) -> void:
	if body is Player:
		body.heating = true

func _on_barrel_body_exited(body: Node2D) -> void:
	if body is Player:
		body.heating = false

func _on_player_in_range(interactive: Interactive) -> void:
	show_action(interactive.item_name)

func _on_player_out_of_range(interactive: Interactive) -> void:
	show_action("")
	interactive.enabled = true

func _on_player_interacted(interactive: Interactive) -> void:
	print("using %s" % interactive.item_name)

func show_action(action: String) -> void:
	action_label.visible = (action != "")
	action_label.text = tr(action)

