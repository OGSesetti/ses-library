####################	MUSIC MANAGER	####################

#	Literally the same shit as Audio Manager. Go look at that for more info.


@tool
extends Node2D

var sound_track_dict: Dictionary = {}

@export var sound_tracks: Array[SoundTrack]

func _ready() -> void:
	for sound_track in sound_tracks:
		sound_track_dict[sound_track.type] = sound_track


func calculate_volume(setting_vol: float, parameter_vol:) -> float:
	var vol = setting_vol * parameter_vol
	return vol


#	Audio playing shit:

func play_song(type: SoundTrack.sound_track_type, vol_modifier: float = 1.0):
	if sound_track_dict.has(type):
		var sound_track: SoundTrack = sound_track_dict[type]
		if sound_track.has_open_limit():
			sound_track.change_audio_count(1)
			var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(new_audio)
			new_audio.stream = sound_track.sound_track


			var volume = calculate_volume(sound_track.volume, vol_modifier)
			new_audio.volume_db = linear_to_db(volume)


			new_audio.pitch_scale = sound_track.pitch_scale

			new_audio.finished.connect(sound_track.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()
	else:
		push_error("AudioManager failed to find settings for type: ", type)







func stop_song():
	pass

func play_bgm():
	pass

func stop_bgm():
	pass

func switch_bgm():
	pass






















"""

# NEW THING MAN
func play_audio(sound_enum, pitch_range: float = 0.0, volume_adjust: float = 1.0):
	var audio_player = AudioStreamPlayer.new()
	var random_pitch = randf_pitch(pitch_range)
	audio_player.pitch_scale = random_pitch
	audio_player.volume_db

	audio_player.stream = sound_enum	#	array here
	
	get_tree().current_scene.add_child(audio_player)
	audio_player.play()

	var timer = Timer.new()
	timer.wait_time = audio_player.stream.get_length()
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_audio_player_finished").bind(audio_player))
	get_tree().current_scene.add_child(timer)
	timer.start()
	
	"""
# väli

"""
func play_sound(sound_path, type, randomized = false, volume_adjust = 1.0):
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


func randf_pitch(pitch):
	var p = randf_range( 1.0 - pitch, 1.0 + pitch)
	return p










	"""
