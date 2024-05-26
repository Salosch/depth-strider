extends StaticBody2D

@export var has_breach = false
@onready var rand_int = 0
@onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 10
	timer.start()
	timer.timeout.connect(_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _timer_timeout() -> void:
	rand_int = rng.randi_range(1, 4)
	var next_damage_name = "damage" + str(rand_int)
	var next_damage = get_node(next_damage_name)
	if not next_damage.visible:
		next_damage.show()
	else:
		var next_breach_name = "breach" + str(rand_int)
		var next_breach = get_node(next_breach_name)
		if not next_breach.visible:
			next_breach.show()
			has_breach = true
