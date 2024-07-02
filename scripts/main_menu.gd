extends Control

@onready var scene_transition = $CanvasLayer/SceneTransition/AnimationPlayer

func _ready():
	AudioPlayer.play_music_menu()
	AudioPlayer.resume_music()

func _on_start_button_pressed():
	Sound.button_click()
	$single_or_coop.show()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	Sound.button_click()
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_help_button_pressed():
	Sound.button_click()
	get_tree().change_scene_to_file("res://scenes/help.tscn")

func _on_coop_button_pressed():
	Sound.button_click()
	self.hide()
	scene_transition.play("fade_in")
	await scene_transition.animation_finished
	Global.is_coop = true
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_single_button_pressed():
	Sound.button_click()
	self.hide()
	scene_transition.play("fade_in")
	await scene_transition.animation_finished
	Global.is_coop = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_back_to_menu_pressed():
	Sound.button_click()
	$single_or_coop.hide()
