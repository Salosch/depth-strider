extends StaticBody2D

var damage_scene = preload("res://scenes/damage.tscn")
var breach_scene = preload("res://scenes/breach.tscn")

var positions = [Vector2(0, 123), Vector2(71, 123), Vector2(-85, 123), Vector2(169, 123), Vector2(-16, 21), Vector2(41, 21), Vector2(-16, 251), Vector2(42, 251)]

var rand_int = 0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 10
	timer.start()
	timer.timeout.connect(_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ShipSprite.play("new_animation")
	$ShipSprite/AnimationPlayer.play("change_pos")
	pass

func _timer_timeout() -> void:
	var position_selected = false
	
	while not position_selected:
		rand_int = rng.randi_range(0, len(positions)-1)
		var position = positions[rand_int]
		
		var damage_name = "Damage" + str(rand_int)
		var breach_name = "Breach" + str(rand_int)
		var damage_exists = false
		var breach_exists = false
		var damage_node = null

		for child in get_children():
			if child.name == damage_name:
				damage_exists = true
				damage_node = child
			elif child.name == breach_name:
				breach_exists = true

		if not damage_exists and not breach_exists:
			# If no damage or breach exists, place a damage scene
			var damage_instance = damage_scene.instantiate()
			damage_instance.position = position
			damage_instance.name = damage_name
			add_child(damage_instance)
			position_selected = true
			
		elif damage_exists and not breach_exists:
			# If only damage exists, place a breach scene on top of it
			var breach_instance = breach_scene.instantiate()
			breach_instance.name = breach_name
			breach_instance.position = position
			damage_node.queue_free()
			add_child(breach_instance)
			position_selected = true
			
		else:
			continue
	

func has_breach() -> bool:
	for child in get_children():
		if child.name.begins_with("Breach"):
			return true
	return false

func respawn_damage(breach_node: Node) -> void:
	var breach_instance_name = breach_node.get_parent().name
	var damage_instance_name = breach_instance_name.replace("Breach", "Damage")
	var pos_number = get_number_from_node_name(breach_instance_name)
	var damage_instance = damage_scene.instantiate()
	
	damage_instance.position = positions[pos_number]
	damage_instance.name = damage_instance_name
	breach_node.get_parent().queue_free()
	add_child(damage_instance)

	
func get_number_from_node_name(node_name: String) -> int:
	var number_str = node_name[-1]
	return number_str.to_int()
