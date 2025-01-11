extends AudioStreamPlayer
var volume : float

func audio_play_sound(sound_path, type, randomized = false, volume_adjust = 1.0):
	



	var audio_player = AudioStreamPlayer.new()
	audio_player.connect("settings_updated", Callable(self, "_on_settings_updated"))
	if randomized == true:
		var random_pitch = randf_range(0.9, 1.1)
		audio_player.pitch_scale = random_pitch
	else:	
		audio_player.pitch_scale = 1
	audio_player.stream = sound_path
	get_tree().current_scene.add_child(audio_player)
	audio_player.play()

	var timer = Timer.new()
	timer.wait_time = audio_player.stream.get_length()
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_audio_player_finished").bind(audio_player))
	get_tree().current_scene.add_child(timer)
	timer.start()
	

	
func _on_audio_player_finished(audio_player: AudioStreamPlayer):
	if audio_player:
		print("audio player cleared")
		audio_player.queue_free()

func _on_update_settings():
	pass