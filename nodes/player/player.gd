extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if Input.is_action_just_pressed("mouse_right"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_released("mouse_right"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion and Input.is_action_pressed("mouse_right"):
		rotate_y(deg_to_rad(-event.relative.x))

func _physics_process(delta):
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
