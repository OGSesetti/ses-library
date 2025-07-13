@tool
extends EditorScript

var scene_path = SesConfig.music_manager_path	# AudioManager	"res://ses/music manager/scenes/music_manager.tscn"
var scene: PackedScene = load(scene_path)
var resource_folder_path: String = SesConfig.music_resource_path
var resource_files: PackedStringArray = DirAccess.get_files_at(resource_folder_path)

var modified: bool

func _run():
	var scene_instance: Node2D = scene.instantiate()
	for file: String in resource_files:
		var file_path: String = resource_folder_path + "/" + file
		var resource: Resource = load(file_path)
		if resource != null and not resource in scene_instance.sound_tracks:
			modified = true
			scene_instance.sound_tracks.append(resource)

	if modified == true:
		scene = PackedScene.new()
		scene.pack(scene_instance)
		ResourceSaver.save(scene, scene_path)
		print("MusicManager updated. Reload the editor.")

	else:
		print("MusicManager was not updated. No new resources were found.")







































"""
asetusresurssi:
	sound
		sound_file
		vol_scale
		pitch_scale
		pitch_variance

pseudokoodi:

	enum sound_tracks	-	tee joku ulkoinen lista

	added_sound_tracks = [array kai? tai dict?s]				-	Vissiin dict. Export varratut asetuselementit voisi olla tässä

	_run():
		
		var sounds = hae sound_tracks_enumit
		var added_sounds = {}

		for sound in sounds:
			if sound is in added_sounds:
				pass
			else:
				it = create_element(sound)
				it.add to list()?

	create_element(s) -> element:
		var e = element.new()?
		lisää export varit resurssista (tai käytä luokkaa?)
		return e

		looppaa läpi ja export varraa asetukset resurssista

"""
