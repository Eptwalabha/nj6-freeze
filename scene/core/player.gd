class_name Player
extends CharacterBody2D

const SPEED = 30.0
const JUMP_VELOCITY = -40.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Sprite2D

var heating : bool = false
var working : bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 50 * delta
	velocity.x = Input.get_axis("move_left", "move_right") * 42.0
	move_and_slide()
	_update_player_states()

func _update_player_states() -> void:
	if velocity.x != 0:
		sprite_2d.flip_h = velocity.x < 0
