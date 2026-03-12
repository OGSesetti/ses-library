############################################ Severi's Essential Systems: ############################################
##################################################	SIGNAL MANAGER	##################################################

#	This signal manager connects automatically to all added nodes that have the variable "uses_signals" that is set to true.
#	Individual signals are connected based on the listening functions a node has. (_on_standard_signal etc.)
#	ID and Command parameters can be used in a match statement to determine the receivers and instructions.

#	Signal parameters in depth:
#		ID == Identifier for the signal. This is how different nodes recognize what signals are meant for them. 
#		command == Similar to ID, but describes the action wanted from the node.
#		data == Information sent along with the signal. There shouldn't be any limitations on the type of data.
#		mute == Determines if the console message is muted or not. The default setting can be changed in the config file.

#	You can also create new signal types by declaring them, adding them to the "signal_names"-array and creating the functions for them.

#	JOS SIGNAL MANAGER AIHEUTTAA KAATUILUA TAI MUITA ONGELMIA, OTA SELVÄÄ KUSEEKO AUTOMAATTISEN CONNECTAUKSEN AJOITUS SIGNAALIEN VASTAANOTON KANSSA

extends Node

var listeners: Array = []

var mute_standard: bool = SesConfig.mute_standard_signals
var mute_command: bool = SesConfig.mute_command_signals
var mute_global: bool = SesConfig.mute_global_signals
var mute_ui: bool = SesConfig.mute_ui_signals

var print_node_added = false

#	Don't fucking remove these
signal standard_signal
signal command_signal
signal global_signal
signal ui_signal
signal stop_bgm
signal hud_update

var print_new_connections: bool = false


var signal_names =[
"standard_signal",	#	id, data, mute
"command_signal",	#	id, command, data
"global_signal",	#	event, data (for more globally used signals)
"ui_signal"	,		#	command but for UI
"kill_bgm",			#	kills background music
"hud_update"
]





func _ready():
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	scan_existing_nodes(get_tree().root)

func scan_existing_nodes(root: Node):
	for child in root.get_children():
		_on_node_added(child)
		scan_existing_nodes(child)

func _on_node_added(node: Node):	#	tätä voisi siivota
	var uses_signals = false
	if print_node_added == true:
		print("SignalManager: Node found: ", node)
	if "uses_signals" in node:
		uses_signals = node.get("uses_signals")
	if uses_signals == true:
		_connect_signals(node)


func _connect_signals(node: Node):
	for n in signal_names:
		var function_name = "on_" + n	#
		if node.has_method(function_name):
			connect(n, Callable(node, function_name))
		if print_new_connections == true:
			print("Connected ", n," to ", node)


#	Prints info about the sent signal. Declaring the type is mandatory.
#	A total of 8 possible variables can be sent as additional info. If you need more I recommend taking a good long look on what the fuck you are even doing
func report_sent_signal(type, a = "", b = "", c = "", d = "", e = "", f = "",g = "", h = ""):
	print_rich("[color=#00E8FC]{SIGNAL MANAGER}[/color] Signal was sent: Type: ", type, a,b,c,d,e,f,g,h)


#	The default type of signal with a handy mute option
func send_standard(id = null, data = "", mute: bool = mute_standard):
	if id == null:
		push_warning("Signal manager: Received instructions with no ID. Delivery can be expected to have failed.")
	emit_signal("standard_signal", id, data)
	if mute == false:
		report_sent_signal("Standard",  "ID:", id, " Data:", data)


#	Basically one extra parameter slot
func send_command(id, command, data = ""):
	if id == null:
		push_warning("Signal manager: Received instructions with no ID. Delivery can be expected to have failed.")
	emit_signal("command_signal", id, command, data)
	if mute_command == false:
		report_sent_signal("Command", ", ID: ", id, ", Command: ", command, ", Data: ", data)


#	Pretty much the same as command. Splitted for better performance
func send_ui(id, command, data = ""):
	if id == null:
		push_warning("Signal manager: Received instructions with no ID. Delivery can be expected to have failed.")
	emit_signal("ui_signal", id, command, data)	######################################################
	if mute_command == false:
		report_sent_signal("UI-Command", ", ID: ", id, ", Command: ", command, ", Data: ", data)


#	No ID. Works everywhere. Need to figure something for the listening though
func send_global(command, data = ""):
	emit_signal("global_signal", command, data)
	if mute_global == false:
		report_sent_signal("Global", ", Command: ", command, "Data: " +  data)


func kill_bgm(fade_time: float):
	emit_signal("stop_bgm", fade_time)
	print("SignalManager: stopping bgm")


func update_hud(id: int, data = ""):
	emit_signal("hud_update", id, data)


func _shut_the_fuck_up():#	NEVER USE THIS
	standard_signal.emit()
	command_signal.emit()
	global_signal.emit()
	ui_signal.emit()
	stop_bgm.emit()
	hud_update.emit()