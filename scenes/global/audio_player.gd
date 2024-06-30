extends AudioStreamPlayer

const menu_music = preload("res://assets/music/menu_music.wav")
var current_music: AudioStream = null
var is_playing = false

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return

	current_music = music
	stream = music
	volume_db = volume
	play()
	is_playing = true

func play_music_menu():
	_play_music(menu_music)

func stop_music():
	stop()
	is_playing = false

func resume_music():
	if current_music != null and not is_playing:
		play()
		is_playing = true
