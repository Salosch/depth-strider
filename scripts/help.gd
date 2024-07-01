extends Node2D


func _ready():
	AudioPlayer.resume_music()

func _on_texture_button_pressed():
	Sound.button_click()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
