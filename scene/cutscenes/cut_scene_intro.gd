class_name CutSceneIntro
extends CutScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func start() -> void:
	super.start()
	animation_player.play("intro")


func wake_up_player() -> void:
	pass
