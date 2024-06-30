extends Control

@onready var scene_transition = $CanvasLayer/SceneTransition/AnimationPlayer

func _ready():
	AudioPlayer.play_music_menu()
	AudioPlayer.resume_music()

func _on_start_button_pressed():
	self.hide()
	scene_transition.play("fade_in")
	await scene_transition.animation_finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_help_button_pressed():
	get_tree().change_scene_to_file("res://scenes/help.tscn")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/options.tscn")
