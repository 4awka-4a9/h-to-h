extends Area2D

enum State {ACTIVATED, DEACTIVATED}
var current_state = State.DEACTIVATED

var can_work = true
var player_inside = false

@onready var timer = $Timer

signal toggled(is_on)

func changeState(new_state: State):
	if current_state == new_state:
		return
		
	current_state = new_state
	
	match current_state:
		State.ACTIVATED:
			activated()
		State.DEACTIVATED:
			deactivated()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = true
		if current_state == State.DEACTIVATED and can_work:
			changeState(State.ACTIVATED)
	
func activated():
	if can_work:
		timer.start(3)
		can_work = false
		toggled.emit(true)
		print("timer started")

func deactivated():
	toggled.emit(false)
	print("deactivated")

func _on_timer_timeout() -> void:
	changeState(State.DEACTIVATED)
	if not player_inside:
		can_work = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
			player_inside = false
			if timer.is_stopped():
				can_work = true
