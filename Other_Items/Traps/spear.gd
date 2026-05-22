extends Area2D

enum State {CAN_DAMAGE, CANT_DAMAGE}
var current_state = State.CANT_DAMAGE

var can_damage = false

func _ready() -> void:
	var plate = get_node("../Plate")
	
	if plate:
		plate.toggled.connect(_on_plate_toggled)

func changeState(new_state: State):
	current_state = new_state
	
	match current_state:
		State.CAN_DAMAGE:
			activated()
		State.CANT_DAMAGE:
			deactivated()

func _on_plate_toggled(is_on: bool):
	if is_on:
		changeState(State.CAN_DAMAGE)
	else:
		changeState(State.CANT_DAMAGE)

func activated():
	can_damage = true
	move_up()
	
	
func deactivated():
	can_damage = false
	move_down()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and can_damage == true:
		body.is_living = false

func move_up():
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 100, 1.0)

func move_down():
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 100, 1.0)
