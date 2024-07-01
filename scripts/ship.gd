extends StaticBody2D

var damage_scene = preload ("res://scenes/damage.tscn")
var breach_scene = preload ("res://scenes/breach.tscn")
@onready var game_node = get_tree().get_root().get_node("Game")

var positions = [Vector2(0, 123), Vector2(71, 123), Vector2( - 85, 123), Vector2(169, 123), Vector2( - 16, 21), Vector2(41, 21), Vector2( - 16, 251), Vector2(42, 251)]

var rand_int = 0
var rng = RandomNumberGenerator.new()
var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	add_child(timer)
	timer.wait_time = 10
	timer.start()
	timer.timeout.connect(_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ShipSprite.play("new_animation")

	if self.has_breach() and not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()
	elif not self.has_breach() and $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.stop()

func _timer_timeout() -> void:
	var position_selected = false
	var distance = game_node.distance
	var new_wait_time = calculate_wait_time(distance)
	
	while not position_selected:
		rand_int = rng.randi_range(0, len(positions) - 1)
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
			$MetalBreaking.play()
			add_child(damage_instance)
			damage_instance.get_node("AnimationPlayer").play("Crack")
			position_selected = true
			
		elif damage_exists and not breach_exists:
			# If only damage exists, place a breach scene on top of it
			var breach_instance = breach_scene.instantiate()
			breach_instance.name = breach_name
			breach_instance.position = position
			damage_node.queue_free()
			$MetalBreaking.play()
			add_child(breach_instance)
			breach_instance.get_node("AnimationPlayer").play("Opencrack")
			breach_instance.get_node("AnimationPlayer").queue("Stars")
			position_selected = true
			
		else:
			continue
	timer.wait_time = new_wait_time
	timer.start()

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
	damage_instance.get_node("AnimationPlayer").play_backwards("Opencrack")
	add_child(damage_instance)
	
func get_number_from_node_name(node_name: String) -> int:
	var number_str = node_name[- 1]
	return number_str.to_int()

func calculate_wait_time(distance: float) -> float:
	var base_wait_time = 10
	var max_distance = 100000
	var min_wait_time = 2.5

	var scaled_wait_time = base_wait_time - (distance / max_distance) * (base_wait_time - min_wait_time)
	
	return max(scaled_wait_time, min_wait_time)
