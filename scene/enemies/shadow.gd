class_name ShadowEnemy
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Pivot/Sprite2D
@onready var eyes: Sprite2D = $Pivot/Eyes
@onready var pivot: Marker2D = $Pivot

const SPEED = 30.0
const ATTACK_RANGE = 5.0

enum ENEMY_STATE {
	DISABLED,
	APPROACHING,
	STAGGERED,
	RUNNING_AWAY,
	ATTACKING,
}

@export var max_light_exposure : float = 2.0

var target : Node2D = null : set = _set_target
var current_state : ENEMY_STATE = ENEMY_STATE.DISABLED
var lit : bool = false : set = _set_lit
var time_lit : float = 0.0
var scared : bool = 0.0
var in_range : bool = false

func _ready() -> void:
	animation_tree.active = true

func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += 20

	match current_state:
		ENEMY_STATE.APPROACHING:
			velocity.x = sign(target.global_position.x - global_position.x) * SPEED
		ENEMY_STATE.RUNNING_AWAY:
			velocity.x = -sign(target.global_position.x - global_position.x) * SPEED * 2.0
		_:
			velocity.x = 0.0

	move_and_slide()
	_update_state_machine()

func _process(delta: float) -> void:
	$Label.text = "state " + str(current_state)
	if scared:
		return
	time_lit = max(time_lit + delta * (1.0 if lit else -0.5), 0.0)
	if time_lit >= max_light_exposure:
		change_state(ENEMY_STATE.RUNNING_AWAY)

func _update_state_machine() -> void:
	if velocity.x != 0:
		pivot.scale.x = -1.0 if velocity.x < 0 else 1.0

	animation_tree.set("parameters/conditions/lit", lit)
	animation_tree.set("parameters/conditions/not-lit", not lit)
	animation_tree.set("parameters/conditions/scared", scared)
	animation_tree.set("parameters/conditions/in-range", in_range)
	animation_tree.set("parameters/conditions/not-in-range", not in_range)

func _set_lit(is_lit) -> void:
	lit = is_lit
	if scared or target == null:
		return
	if lit:
		change_state(ENEMY_STATE.STAGGERED)
	else:
		change_state(ENEMY_STATE.APPROACHING)

func punch() -> void:
	if in_range:
		print("ouch!")
	current_state = ENEMY_STATE.APPROACHING

func _set_target(new_target: Node2D) -> void:
	target = new_target
	if current_state == ENEMY_STATE.DISABLED:
		change_state(ENEMY_STATE.APPROACHING)

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body == target:
		in_range = true
		change_state(ENEMY_STATE.ATTACKING)

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body == target:
		in_range = false
		change_state(ENEMY_STATE.APPROACHING)

func change_state(new_state: ENEMY_STATE) -> void:
	if current_state == ENEMY_STATE.RUNNING_AWAY:
		return

	if new_state == ENEMY_STATE.RUNNING_AWAY:
		current_state = new_state
		scared = true
		await get_tree().create_timer(5.0).timeout
		queue_free()
	elif lit:
		current_state = ENEMY_STATE.STAGGERED
	elif current_state == ENEMY_STATE.ATTACKING and new_state == ENEMY_STATE.APPROACHING:
		return
	else:
		current_state = new_state
