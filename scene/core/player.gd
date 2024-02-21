class_name Player
extends CharacterBody2D

const SPEED = 15.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Sprite2D

var heating : bool = false
var working : bool = false

func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 50 * delta
	velocity.x = Input.get_axis("move_left", "move_right") * SPEED
	move_and_slide()
	_update_player_states()

func _update_player_states() -> void:
	var moving = false
	if velocity.x != 0:
		moving = true
		sprite_2d.flip_h = velocity.x < 0
	animation_tree.set("parameters/conditions/moving", moving)
	animation_tree.set("parameters/conditions/idle", not moving)
