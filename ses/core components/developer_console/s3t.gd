extends Control

# Severi's Shitty Signal Terminal

@onready var text_field = $%TextField
@onready var text_input = $%TextInput

#var commands: Dictionary = {}





func _ready() -> void:
	print_start_info()



func print_start_info():
	output("Severi's Shitty Signal Terminal")
	output("All rights relieved")








func output(a):
	text_field.append_text(a)
	text_field.append_text("\n")
	pass

func ln():
	output("\n")
	print("lazy fuck")


func _on_text_input_text_submitted(input:String) -> void:
	var command = input.split(" ")
	output(input)
	execute(command)
	text_input.text = ""


func execute(c):
	match c[0]:
		"sig":
			if c[1] and c[2]:
				SignalManager.send_standard(c[1], c[2], c[3])

		"cmd":
			if c[1] and c[2]:
				SignalManager.send_command(c[1], c[2], c[3])

		"gcmd":
			if c[1]:
				SignalManager.send_global(c[1], c[2])

		"ui":
			if c[1] and c[2]:
				SignalManager.send_ui(c[1], c[2], c[3])

		"vol":
			var volume = float(c[1])
			if c[1].is_valid_float():
				if volume >= 0.0 and volume <= 100.0:
						volume = volume / 100
						#print("Volume: ", volume)
						var data = ["vol", volume]
						SignalManager.send_command("settings", "set", data)


		"sfx":
			var volume = float(c[1])
			if c[1].is_valid_float():
				if volume >= 0.0 and volume <= 100.0:
						volume = volume / 100
						#print("Volume: ", volume)
						var data = ["sfx", volume]
						SignalManager.send_command("settings", "set", data)



		"music":
			var volume = float(c[1])
			if c[1].is_valid_float():
				if volume >= 0.0 and volume <= 100.0:
						volume = volume / 100
						#print("Volume: ", volume)
						var data = ["vol", volume]
						SignalManager.send_command("settings", "music", data)


		"fs":
			pass

		"quit":
			get_tree().quit()
