class_name Player
extends CharacterBody2D

const SPEED = 50.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var torch: PointLight2D = $Light/Torch
@onready var torch_target: Marker2D = $Pivot/TorchTarget

var is_light_on : bool = false
var heating : bool = false
var working : bool = false

var force_target : ForceTrigger

var force_ready : bool = false

enum PLAYER_STATE {
	CUTSCENE,
	DISABLED,
	CONTROL,
	FORCE,
}

var current_state : PLAYER_STATE = PLAYER_STATE.CONTROL : set = _set_current_state

func _ready() -> void:
	switch_flashlight(false)
	GameData.flashlight_found.connect(switch_flashlight.bind(true))
	GameData.force_trigger_entered.connect(_on_force_trigger_entered)
	GameData.force_trigger_exited.connect(_on_force_trigger_exited)
	animation_tree.active = true
	_set_current_state(current_state)

func _physics_process(_delta: float) -> void:
	if current_state == PLAYER_STATE.DISABLED:
		return

	if not is_on_floor():
		velocity.y += 20

	match current_state:
		PLAYER_STATE.CONTROL:
			velocity.x = Input.get_axis("move_left", "move_right") * SPEED
		PLAYER_STATE.FORCE:
			# move to target
			velocity.y = 0
			velocity.x = 0
		PLAYER_STATE.CUTSCENE:
			velocity.x = 0

	move_and_slide()
	_update_player_states()

func reset() -> void:
	switch_flashlight(GameData.current_checkpoint_id != 0)

func _process(delta: float) -> void:
	torch.global_position = torch.global_position.lerp(torch_target.global_position, delta * 8.0)

func _input(event: InputEvent) -> void:
	if force_ready:
		if event.is_action_pressed("action-confirm"):
			current_state = PLAYER_STATE.FORCE
			animation_tree.set("parameters/conditions/force-start", true)
			animation_tree.set("parameters/force/conditions/force-release", false)
			GameData.ui_agility_pressed.emit()
		elif event.is_action_released("action-confirm"):
			animation_tree.set("parameters/conditions/force-start", false)
			animation_tree.set("parameters/force/conditions/force-release", true)
			current_state = PLAYER_STATE.CONTROL
			GameData.ui_agility_released.emit()

func _update_player_states() -> void:
	var moving = false
	if velocity.x != 0:
		moving = true
		sprite_2d.flip_h = velocity.x < 0
	$Pivot.scale.x = -1.0 if sprite_2d.flip_h else 1.0
	animation_tree.set("parameters/conditions/moving", moving)
	animation_tree.set("parameters/conditions/idle", not moving)
	animation_tree.set("parameters/conditions/moving", moving)
	animation_tree.set("parameters/conditions/idle", not moving)
	animation_tree.set("parameters/conditions/falling-down", velocity.y > 0.0)
	animation_tree.set("parameters/conditions/not-on-floor", not is_on_floor())
	animation_tree.set("parameters/conditions/on-floor", is_on_floor())

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is ShadowEnemy:
		body.lit = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is ShadowEnemy:
		body.lit = false

func _set_current_state(new_state: PLAYER_STATE) -> void:
	current_state = new_state
	set_physics_process(current_state != PLAYER_STATE.DISABLED)
	set_process_input(current_state == PLAYER_STATE.CONTROL or current_state == PLAYER_STATE.FORCE)

func _on_force_trigger_entered(target: ForceTrigger) -> void:
	force_target = target
	force_ready = true

func _on_force_trigger_exited() -> void:
	force_ready = false

func is_looking_left() -> bool:
	return sprite_2d.flip_h

func switch_flashlight(on: bool) -> void:
	is_light_on = on
	$Light.visible = on
	$Light/Torch/Area2D.set_deferred("monitoring", on)

func _on_bob_player_grabbed() -> void:
	switch_flashlight(false)
	sprite_2d.visible = false
	current_state = PLAYER_STATE.CUTSCENE
