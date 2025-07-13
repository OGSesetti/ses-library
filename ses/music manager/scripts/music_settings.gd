class_name SoundTrack
extends Resource

var uses_signals = true

enum sound_track_type {	#	ÄÄNET TÄNNE
MAIN_MENU_THEME,
TEXAS_THEME,
BATTLE_THEME

}



@export var type: sound_track_type
@export var sound_track: AudioStream	#	Tää type saattaa paskoa housuun. Originalissa on AudioStreamMP3 tai jtn
@export_range(0.0, 2.0,.01) var volume: float = 1.0
@export_range(0.0, 4.0,.01) var pitch_scale: float = 1.0


var audio_count: int = 0


