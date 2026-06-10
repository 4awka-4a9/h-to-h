extends Area2D

enum State {CLOSED, OPEN}
var current_state = State.CLOSED

@onready var anim = $AnimatedSprite2D
@onready var curent_scene = get_parent().name
@onready var curent_scene_number = curent_scene.replace("level", "")
@onready var next_level = str(curent_scene_number.to_int() + 1)

var is_inside = false

var UI_interact = preload("res://Assets/UI/Interact_message.tscn")
var new_UI_interact

func _ready() -> void:
	var switch = get_node("../Switch")
	
	if switch:
		switch.toggled.connect(_on_switch_toggled)

func _process(delta: float) -> void:
	match current_state:
		State.CLOSED:
			closed()
		State.OPEN:
			open()
	

func open():
	anim.play("Open")
	escape()

func closed():
	anim.play("Closed")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_inside = true
		label_create()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_inside = false
		label_delete()

func _on_switch_toggled(is_on: bool):
	if is_on:
		current_state = State.OPEN
	else:
		current_state = State.CLOSED

func escape():
	if is_inside and Input.is_action_just_pressed("Interact"):
		get_tree().change_scene_to_file("res://Scenes/Levels/level" + next_level + ".tscn")

func label_create():
	new_UI_interact = UI_interact.instantiate()
	new_UI_interact.position = Vector2(310, 360)
	get_parent().add_child(new_UI_interact)

func label_delete():
	if is_instance_valid(new_UI_interact):
			new_UI_interact.queue_free()
