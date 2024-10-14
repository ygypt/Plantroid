extends CharacterBody2D


const SPEED = 500
const JUMP_VELOCITY = -1000
const FALL_SPEED = 1000


@export var state_chart: StateChart


var move_axis: int = 0:
	get: return Input.get_axis("move_left", "move_right")


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_idle_state_physics_processing(delta: float) -> void:
	velocity.y = FALL_SPEED
	
	if not is_on_floor():
		print("not on floor")
		state_chart.send_event(&"fall")

	if Input.is_action_just_pressed("jump"):
		state_chart.send_event(&"jump")

	var direction := move_axis
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func _on_fall_state_physics_processing(delta: float) -> void:
	velocity.y = FALL_SPEED
	
	if is_on_floor():
		state_chart.send_event(&"land")


func _on_jump_state_physics_processing(delta: float) -> void:
	velocity.y = JUMP_VELOCITY
	
	if not Input.is_action_pressed("jump"):
		state_chart.send_event(&"fall")
