extends StaticBody2D

var damage_scene = preload("res://scenes/damage.tscn")
var breach_scene = preload("res://scenes/breach.tscn")

var positions = [Vector2(-93, 173), Vector2(10, 173), Vector2(150, 173), Vector2(300, 173)]

@onready var rand_int = 0
@onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()  # Ensure the RNG is properly seeded
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
		rand_int = rng.randi_range(0, 3)
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
