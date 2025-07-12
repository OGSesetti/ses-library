####################	AUDIO MANAGER	####################

#	Spike prevention and file managing method ideas have been nicked from the AudioManager system by Aarimous:
#	https://github.com/Aarimous/AudioManager
#	Modifications made by me include: More accurate volume scaling, adjustable volume from the function call, logarithmic pitch scaling that SHOULD work a bit better


#	sound_effects = the resources that are used in playing sound effects
#	sound_effect_files = the audio files
@tool
extends Node2D

var sound_effect_dict: Dictionary = {}

@export var sound_effects: Array[SoundEffect]

func _ready() -> void:
	for sound_effect in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect


func calculate_volume(setting_vol: float, parameter_vol:) -> float:
	var vol = setting_vol * parameter_vol
	return vol

func randomize_pitch(pitch_variance: float) -> float:
	var pitch = randf_range(1.0 - pitch_variance, 1.0 + pitch_variance)
	return pitch




#	Audio playing shit:

func play_global(type: SoundEffect.sound_effect_type, vol_modifier: float = 1.0, disable_random_pitch: bool = false):
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(new_audio)
			new_audio.stream = sound_effect.sound_effect


			var volume = calculate_volume(sound_effect.volume, vol_modifier)
			new_audio.volume_db = linear_to_db(volume)


			new_audio.pitch_scale = sound_effect.pitch_scale

			if disable_random_pitch == false:
				var pitch_variation = randomize_pitch(sound_effect.pitch_variance)
				new_audio.pitch_scale = new_audio.pitch_scale * pitch_variation


			new_audio.finished.connect(sound_effect.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()
	else:
		push_error("AudioManager failed to find settings for type: ", type)




func play_locational(location: Vector2, type: SoundEffect.sound_effect_type, vol_modifier: float = 1.0, disable_random_pitch: bool = false):
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_audio_2d: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			add_child(new_audio_2d)
			new_audio_2d.position = location
			new_audio_2d.stream = sound_effect.sound_effect


			var volume = calculate_volume(sound_effect.volume, vol_modifier)
			new_audio_2d.volume_db = linear_to_db(volume)


			new_audio_2d.pitch_scale = sound_effect.pitch_scale

			if disable_random_pitch == false:
				var pitch_variation = randomize_pitch(sound_effect.pitch_variance)
				new_audio_2d.pitch_scale = new_audio_2d.pitch_scale * pitch_variation


			new_audio_2d.finished.connect(sound_effect.on_audio_finished)
			new_audio_2d.finished.connect(new_audio_2d.queue_free)
			new_audio_2d.play()
	else:
		push_error("AudioManager failed to find settings for type: ", type)


func play_song():
	pass

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
