extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	check_message()
	
func check_message() -> void:
	var detected = get_overlapping_bodies()
	for body in detected:
		if body is StaticBody2D:
			continue
		body._on_message_hitbox_area_entered(self)
