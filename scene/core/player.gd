class_name Player
extends CharacterBody2D

const SPEED = 50.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var torch: PointLight2D = $Light/Torch
@onready var torch_target: Marker2D = $Pivot/TorchTarget

var heating : bool = false
var working : bool = false

func _ready() -> void:
	animation_tree.active = true

func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += 20
	velocity.x = Input.get_axis("move_left", "move_right") * SPEED
	move_and_slide()
	_update_player_states()

func _process(delta: float) -> void:
	torch.global_position = torch.global_position.lerp(torch_target.global_position, delta * 8.0)

func _update_player_states() -> void:
	var moving = false
	if velocity.x != 0:
		moving = true
		sprite_2d.flip_h = velocity.x < 0
	$Pivot.scale.x = -1.0 if sprite_2d.flip_h else 1.0
	animation_tree.set("parameters/conditions/moving", moving)
	animation_tree.set("parameters/conditions/idle", not moving)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is ShadowEnemy:
		body.lit = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is ShadowEnemy:
		body.lit = false
