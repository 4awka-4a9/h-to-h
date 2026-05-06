extends Node2D

enum State {TURN_OFF, TURN_ON}
var current_state = State.TURN_OFF

@onready var anim = $AnimatedSprite2D

var UI_interact = preload("res://Assets/UI/Interact_message.tscn")
var new_UI_interact

var turned_on = false
var player_inside = false

signal toggled(is_on)

func _process(delta: float) -> void:
	match current_state:
		State.TURN_OFF:
			turn_off()
		State.TURN_ON:
			turn_on()
	
func turn_off():
	anim.play("Off")
	toggled.emit(false)
	
	if Input.is_action_just_pressed("Interact") and player_inside == true:
			current_state = State.TURN_ON

func turn_on():
	anim.play("On")
	toggled.emit(true)
	
	if Input.is_action_just_pressed("Interact") and player_inside == true:
			current_state = State.TURN_OFF

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = true
		label_create()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = false
		label_delete()

func label_create():
	new_UI_interact = UI_interact.instantiate()
	new_UI_interact.position = Vector2(310, 360)
	get_parent().add_child(new_UI_interact)

func label_delete():
	if is_instance_valid(new_UI_interact):
			new_UI_interact.queue_free()
