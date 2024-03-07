extends Camera2D

var target: Vector2 = Vector2.ZERO

@onready var marker: Marker2D = $Marker2D


func _ready() -> void:
	GameUI.phone_drawn.connect(_on_phone_drawn)
	GameUI.phone_hidden.connect(_on_phone_hidden)
	position = target


func _process(delta: float) -> void:
	position = position.slerp(target, delta * GameData.DRAWN_SPEED)


func _on_phone_drawn() -> void:
	target = marker.position


func _on_phone_hidden() -> void:
	target = Vector2.ZERO
