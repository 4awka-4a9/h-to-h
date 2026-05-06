extends RigidBody2D

enum State {FALLING, STATIC}
var current_state = State.STATIC

func _physics_process(delta: float) -> void:
	
	match current_state:
		State.STATIC:
			static_logic()
		State.FALLING:
			falling_logic()

func static_logic():
	freeze = true

func falling_logic():
	freeze = false

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		current_state = State.FALLING

func _on_damager_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.is_living = false
