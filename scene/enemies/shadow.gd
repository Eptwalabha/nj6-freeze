class_name ShadowEnemy
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Pivot/Sprite2D
@onready var eyes: Sprite2D = $Pivot/Eyes
@onready var pivot: Marker2D = $Pivot

const SPEED: float = 15.0
const ESCAPE_SPEED: float = 75.0

var recover_timer : float = 0.0

enum ENEMY_STATE {
	DISABLED,
	CHASING,
	STAGGERED,
	RECOVERING,
	ESCAPING,
	ATTACKING,
}

@export var full_recover_duration: float = 1.0
@export var max_light_exposure : float = 2.0


var target : Node2D = null : set = _set_target
var recovery_rate : float = -max_light_exposure / full_recover_duration
var current_state : ENEMY_STATE = ENEMY_STATE.DISABLED
var dist_to_target : float = 10000.0

var time_lit : float = 0.0

var lit : bool = false
var scared : bool = 0.0
var in_range : bool = false
var attacking : bool = false
var waiting : bool = false

func _ready() -> void:
	recovery_rate = -max_light_exposure / full_recover_duration
	animation_tree.active = true

func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += 20

	match current_state:
		ENEMY_STATE.CHASING:
			if not waiting:
				velocity.x = sign(target.global_position.x - global_position.x) * SPEED
			else:
				velocity.x = 0.0
		ENEMY_STATE.ESCAPING:
			velocity.x = -sign(target.global_position.x - global_position.x) * ESCAPE_SPEED
		_:
			velocity.x = 0.0

	move_and_slide()
	_update_animation_tree_states()

func _process(delta: float) -> void:
	$Label.text = "state " + str(current_state)
	if scared:
		return
	time_lit = max(time_lit + delta * (1.0 if lit else recovery_rate), 0.0)
	update_state()

func update_state() -> void:
	if time_lit >= max_light_exposure:
		escape()
	if current_state == ENEMY_STATE.ESCAPING:
		return

	in_range = in_range and abs(global_position.x - target.global_position.x) < 20

	match current_state:
		ENEMY_STATE.RECOVERING:
			if time_lit == 0.0:
				current_state = ENEMY_STATE.CHASING
		ENEMY_STATE.CHASING:
			if in_range and not lit:
				attack_target()
		ENEMY_STATE.STAGGERED:
			if not lit:
				current_state = ENEMY_STATE.RECOVERING
	
	if lit and current_state != ENEMY_STATE.ESCAPING:
		attacking = false
		current_state = ENEMY_STATE.STAGGERED

func is_in_penumbra() -> bool:
	return dist_to_target > 20 and dist_to_target < 38

func is_target_looking_at_me() -> bool:
	if target == null:
		return false
	var is_left_to_target : bool = sign(target.global_position.x - global_position.x) > 0.0
	if target.is_looking_left():
		return is_left_to_target
	else:
		return not is_left_to_target

func _update_animation_tree_states() -> void:
	if velocity.x != 0:
		pivot.scale.x = -1.0 if velocity.x < 0 else 1.0
	dist_to_target = abs(target.global_position.x - global_position.x)

	waiting = is_target_looking_at_me() and is_in_penumbra()

	animation_tree.set("parameters/conditions/lit", lit)
	animation_tree.set("parameters/conditions/not-lit", not lit)
	animation_tree.set("parameters/conditions/scared", scared)
	animation_tree.set("parameters/conditions/recovered", time_lit == 0.0)
	animation_tree.set("parameters/conditions/attacking", attacking)
	animation_tree.set("parameters/conditions/waiting", waiting)
	animation_tree.set("parameters/conditions/not-waiting", not waiting)

func punch() -> void:
	if in_range and target:
		print("ouch!")

func attack_finished() -> void:
	if not in_range:
		attacking = false
		current_state = ENEMY_STATE.CHASING

func _set_target(new_target: Node2D) -> void:
	target = new_target
	if current_state == ENEMY_STATE.DISABLED:
		current_state = ENEMY_STATE.CHASING

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body == target:
		in_range = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body == target:
		in_range = false

func attack_target() -> void:
	if lit:
		attacking = false
		return
	attacking = true
	current_state = ENEMY_STATE.ATTACKING

func escape() -> void:
	scared = true
	attacking = false
	current_state = ENEMY_STATE.ESCAPING
	await get_tree().create_timer(5.0).timeout
	queue_free()
