extends CharacterBody2D

const SPEED = 200

func _physics_process(delta):
	velocity = Input.get_vector("ui_left", "ui_right", "", "") * SPEED
	move_and_slide()
