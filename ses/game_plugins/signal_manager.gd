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


#	The signals are divided into multiple types to reduce unnecessary checks in the listening nodes.
#	The different signal types can be used pretty freely, but here is the way I intended for them to be used:

#		standard_signal:
#			Your basic one-off signal that can be used to trigger actions and move data around. Only real advantages this has
#			compared to the command_signal is the simplicity and the ability to selectively decide which signals get printed to the console.

#		command_signal:
#			Basically standard_signal with an extra parameter. Useful when one node has to be able to do multiple different actions. 

#		global_signal:
#			Command_signal without the ID. With proper logic a node should be able to listen to both directed commands and global commands.
#			I see little use for this outside of console commands and world event triggers, so it is probably wise to use this sparingly.

#		ui_signal:
#			Another command_signal, but directed towards UI-related nodes for the sake of performance.

#	You can also create new signal types by declaring them, adding them to the "signal_names"-array and creating the functions for them.



extends Node

var listeners: Array = []

var mute_standard: bool = SesConfig.mute_standard_signals
var mute_command: bool = SesConfig.mute_command_signals
var mute_global: bool = SesConfig.mute_global_signals
var mute_ui: bool = SesConfig.mute_ui_signals


signal standard_signal
signal command_signal
signal global_signal
signal ui_signal
signal time_signal

var signal_names =[
"standard_signal",	#	id, data, mute
"command_signal",	#	id, command, data
"global_signal",	#	event, data (for more globally used signals)
"ui_signal"	,		#	command but for UI




"time_signal"		#	Constant global time signal in String form: "%s.%s.%s %s:%s:%s" % [year_string, month_string, day_string, hour_string, minute_string, second_string]
					#	Not in use. Needs a function that actively broadcasts the time. Pretty useless in a video game probably.
]





func _ready():
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	scan_existing_nodes(get_tree().root)

func scan_existing_nodes(root: Node):
	for child in root.get_children():
		_on_node_added(child)
		scan_existing_nodes(child)

func _on_node_added(node: Node):
	var uses_signals = false
	print("SignalManager: New node found")
	if "uses_signals" in node:
		uses_signals = node.get("uses_signals")
	if uses_signals == true:
		_connect_signals(node)


func _connect_signals(node: Node):
	for n in signal_names:
		var function_name = "on_" + n	#
		if node.has_method(function_name):
			connect(n, Callable(node, function_name))
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
	emit_signal("ui_signal", id, command, data)
	if mute_command == false:
		report_sent_signal("UI-Command", ", ID: ", id, ", Command: ", command, ", Data: ", data)

#	No ID. Works everywhere. Need to figure something for the listening though
func send_global(command, data = ""):
	emit_signal("global_signal", command, data)
	if mute_global == false:
		report_sent_signal("Global", ", Command: ", command, "Data: " +  data)

#	This will most likely be obsolete outside the calendar app
func send_time(data, mute = mute_time):
	emit_signal("time_signal", data)
	if mute == false:
		report_sent_signal("Time", ", Data: ", data)

