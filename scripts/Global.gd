extends Node

var scores : Dictionary = {}
var final_score: int = 0
var death_message: String = ""
var is_coop: bool = false

const SAVE_FILE_PATH = "res://score/scores.save"

func _ready():
	load_scores()

func save_scores():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(scores)
		file.close()
	else:
		print("Error saving scores")

func load_scores():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			scores = file.get_var()
			file.close()
		else:
			print("Error loading scores")
