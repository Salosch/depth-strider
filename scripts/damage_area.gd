extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_repair()
	
func check_repair() -> void:
	var detected = get_overlapping_bodies()
	for body in detected:
		if body is StaticBody2D:
			continue
		body._on_damage_hitbox_area_entered(self)
