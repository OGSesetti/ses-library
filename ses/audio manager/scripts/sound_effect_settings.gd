class_name SoundEffect
extends Resource

enum sound_effect_type {	#	ÄÄNET TÄNNE
GUN_JESSE_1,
GUN_JESSE_2,
FOOTSTEPS

}



@export_range (0, 10) var limit: int = 5
@export var type: sound_effect_type
@export var sound_effect: AudioStream	#	saattaa paskoa housuun
@export_range(0.0, 2.0,.01) var volume: float = 1.0
@export_range(0.0, 4.0,.01) var pitch_scale: float = 1.0
@export_range(0.0, 1.0,.01) var pitch_variance: float = 0.0

var audio_count: int = 0


func change_audio_count(amount: int) -> void:
	audio_count = max(0, audio_count + amount)


func has_open_limit() -> bool:
	return audio_count < limit


func on_audio_finished() -> void:
	change_audio_count(-1)
