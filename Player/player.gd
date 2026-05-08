extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

enum State {IDLE, MOVE, JUMP, FALL}
var current_state = State.IDLE
var is_living = true

const SPEED = 100
const JUMP_VELOCITY = -250

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
			velocity += get_gravity() * delta
			
	if is_living:
		match current_state:
			
			State.IDLE:
				idle_logic()
			State.MOVE:
				move_logic()
			State.JUMP:
				jump_logic()
			State.FALL:
				jump_logic()
	else:
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/Levels/level1.tscn")
		
	move_and_slide()
	update_animations()

func idle_logic():
	
	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.get_axis("left", "right") != 0:
		current_state = State.MOVE
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()

func move_logic():
	
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		current_state = State.IDLE

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()
		
	if not is_on_floor():
		current_state = State.FALL

func jump_logic():
	
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * SPEED
	
	if is_on_floor():
		
		if velocity.x == 0:
			current_state = State.IDLE
		else:
			current_state = State.MOVE

func jump():
	
	velocity.y = JUMP_VELOCITY
	current_state = State.JUMP

func update_animations():
	
	anim.flip_h = get_global_mouse_position().x > global_position.x
	
	match current_state:
		
		State.IDLE:
			anim.play("Idle")
		State.MOVE:
			anim.play("Move")
		State.JUMP, State.FALL:
			anim.play("Fall")
